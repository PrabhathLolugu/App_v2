import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/app_theme.dart';
import 'package:myitihas/core/cache/services/cache_cleanup_service.dart';
import 'package:myitihas/core/config/env.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/core/migration/hive_migration_service.dart';
import 'package:myitihas/core/navigation/edge_swipe_back_wrapper.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_event.dart';
import 'package:myitihas/core/presentation/widgets/offline_banner.dart';
import 'package:myitihas/core/widgets/glass/glass_background.dart';
import 'package:myitihas/features/notifications/presentation/cubit/notification_count_cubit.dart';
import 'package:myitihas/firebase_options.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/services/fcm_service.dart';
import 'package:myitihas/services/deep_link_service.dart';
import 'package:myitihas/services/people_connect_follow_limit_service.dart';
import 'package:myitihas/services/people_connect_suggestion_storage_service.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/realtime_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthChangeEvent, AuthState;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -------- Infra (main branch) --------
  initTalker();
  talker.info('Starting MyItihas app...');

  Bloc.observer = createBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Brick repository using secure environment variables
  MyItihasRepository.configure(
    supabaseUrl: Env.supabaseUrl,
    supabaseAnonKey: Env.supabaseAnonKey,
  );

  await configureDependencies();
  talker.info('Dependencies configured');

  // Run Hive migration cleanup (non-blocking)
  final migrationService = getIt<HiveMigrationService>();
  migrationService.runMigration().catchError((e) {
    talker.error('Hive migration failed', e);
  });

  // Initialize cache cleanup (non-blocking)
  final cleanupService = getIt<CacheCleanupService>();
  cleanupService.runCleanup().catchError((e) {
    talker.error('Cache cleanup failed', e);
  });

  // Restore user-selected locale so it persists across restarts (BG_16).
  // All supported locales in AppLocale are now fully translated and supported.
  final SharedPreferences storage = await SharedPreferences.getInstance();
  const localeKey = 'app_locale';
  final savedLocale = storage.getString(localeKey);
  if (savedLocale != null && savedLocale.isNotEmpty) {
    try {
      await LocaleSettings.setLocaleRaw(savedLocale);
      talker.info('Restored locale: $savedLocale');
    } catch (e) {
      talker.warning(
        'Failed to restore locale "$savedLocale", using device: $e',
      );
      await LocaleSettings.useDeviceLocale();
    }
  } else {
    await LocaleSettings.useDeviceLocale();
  }

  // -------- Auth (your branch) --------
  await SupabaseService.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  final fcmService = getIt<FCMService>();
  // Wire up notification tap handling immediately so taps deep-link even when
  // the app is launched from a terminated state (and before auth init runs).

  Future<void> initializeFcmForCurrentUser(String reason) async {
    if (SupabaseService.client.auth.currentUser == null) {
      talker.debug(
        'Skipping FCM initialization ($reason): no authenticated user',
      );
      return;
    }

    try {
      await fcmService.initialize();
      talker.info('FCMService initialized ($reason)');
    } catch (e, stackTrace) {
      talker.error('FCM initialization failed ($reason)', e, stackTrace);
    }
  }

  // Keep FCM token lifecycle synced with auth events so push works even when
  // users sign in after app launch (no restart required).
  SupabaseService.onAuthStateChange.listen((AuthState authState) {
    switch (authState.event) {
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.initialSession:
      case AuthChangeEvent.tokenRefreshed:
        initializeFcmForCurrentUser('auth:${authState.event.name}');
        if (authState.event == AuthChangeEvent.signedIn) {
          SupabaseService.authService
              .ensureUserAndProfileAfterSignIn()
              .catchError((e) {
                talker.warning(
                  'ensureUserAndProfileAfterSignIn (auth event): $e',
                );
              });
        }
        break;
      case AuthChangeEvent.signedOut:
        fcmService.deleteToken().catchError((e, stackTrace) {
          talker.warning('FCM token cleanup failed on sign out: $e');
          talker.debug('FCM sign-out cleanup stacktrace: $stackTrace');
        });
        break;
      default:
        break;
    }
  });

  getIt.registerLazySingleton<PeopleConnectFollowLimitService>(
    () => PeopleConnectFollowLimitService(storage),
  );

  getIt.registerLazySingleton<PeopleConnectSuggestionStorageService>(
    () => PeopleConnectSuggestionStorageService(storage),
  );

  // IMPORTANT: Create router FIRST to register refreshStream
  // This must happen before starting deep link listener
  final GoRouter router = MyItihasRouter().router;

  // Navigate when user opens app from push notification (story, chat, etc.)
  fcmService.notificationOpenStream.listen((data) {
    String asString(dynamic value) {
      if (value == null) return '';
      return value.toString().trim();
    }

    bool asBool(dynamic value) {
      if (value is bool) return value;
      final normalized = asString(value).toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }

    final notificationType = asString(
      data['notification_type'] ?? data['type'] ?? data['notificationType'],
    ).toLowerCase();
    final entityType = asString(
      data['entity_type'] ?? data['entity'] ?? data['entityType'],
    ).toLowerCase();
    final entityId = asString(
      data['entity_id'] ?? data['id'] ?? data['entityId'],
    );
    final parentEntityType = asString(data['parent_entity_type']).toLowerCase();
    final parentEntityId = asString(data['parent_entity_id']);
    final contentType = asString(
      data['content_type'] ?? data['contentType'],
    ).toLowerCase();
    final targetCommentId = asString(data['target_comment_id']);
    final resolvedEntityType = parentEntityType.isNotEmpty
        ? parentEntityType
        : entityType;
    final resolvedEntityId = parentEntityId.isNotEmpty
        ? parentEntityId
        : entityId;
    final conversationIdFromPayload = asString(
      data['conversation_id'] ??
          data['conversationId'] ??
          data['thread_id'] ??
          data['threadId'] ??
          data['chat_id'] ??
          data['chatId'],
    );
    final conversationId = conversationIdFromPayload.isNotEmpty
        ? conversationIdFromPayload
        : (entityType == 'conversation' ? entityId : '');
    final actionUrl = asString(
      data['url'] ?? data['action_url'] ?? data['actionUrl'],
    );

    String resolvePostType() {
      final source = (contentType.isNotEmpty ? contentType : resolvedEntityType)
          .toLowerCase();
      switch (source) {
        case 'text':
        case 'text_post':
        case 'textpost':
        case 'thought':
          return 'text';
        case 'video':
        case 'video_post':
        case 'videopost':
          return 'video';
        default:
          return 'image';
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (actionUrl.isNotEmpty) {
        try {
          final uri = Uri.parse(actionUrl);
          final route = DeepLinkService.parseDeepLink(uri);
          if (route != null) {
            router.push(route.toRoutePath());
            return;
          }
        } catch (_) {
          // Fall through to entity-based routing.
        }
      }

      if (conversationId.isNotEmpty &&
          (notificationType == 'message' ||
              notificationType == 'group_message' ||
              entityType == 'conversation')) {
        final senderId = asString(data['sender_id'] ?? data['actor_id']);
        final rawName = asString(data['sender_name'] ?? data['senderName']);
        final rawTitle = asString(data['title']);
        final avatarUrl = asString(
          data['sender_avatar_url'] ?? data['avatar_url'],
        );
        final isGroup = asBool(data['is_group']);

        unawaited(
          fcmService.clearChatNotificationForConversation(conversationId),
        );

        Future<String> resolveDisplayName() async {
          final candidate = rawName.isNotEmpty ? rawName : rawTitle;
          // Treat "Chat" / empty / email-like handles as low-confidence.
          final lowConfidence =
              candidate.isEmpty ||
              candidate.toLowerCase() == 'chat' ||
              candidate.contains('@');
          if (!lowConfidence) return candidate;
          if (senderId.isEmpty) return candidate.isEmpty ? 'Chat' : candidate;
          try {
            final profile = await getIt<ProfileService>().getProfileById(
              senderId,
            );
            final fullName = asString(profile['full_name']);
            if (fullName.isNotEmpty) return fullName;
            final username = asString(profile['username']);
            if (username.isNotEmpty) return username;
          } catch (_) {}
          return candidate.isEmpty ? 'Chat' : candidate;
        }

        unawaited(() async {
          final displayName = await resolveDisplayName();

          // If app was opened from a notification (cold start), ensure we have
          // a base route so Back doesn't feel like a restart.
          if (!router.canPop()) {
            router.go('/home');
          }

          router.push(
            '/chat_detail',
            extra: {
              'conversationId': conversationId,
              'userId': senderId,
              'name': displayName,
              'avatarUrl': avatarUrl.isEmpty ? null : avatarUrl,
              'isGroup': isGroup,
            },
          );
        }());
        return;
      }

      if (resolvedEntityType == 'story' && resolvedEntityId.isNotEmpty) {
        router.push('/home/stories/$resolvedEntityId');
        return;
      }

      if (resolvedEntityId.isNotEmpty &&
          (resolvedEntityType == 'post' ||
              resolvedEntityType == 'text' ||
              resolvedEntityType == 'video' ||
              resolvedEntityType == 'comment')) {
        final postType = resolvePostType();
        final encodedId = Uri.encodeComponent(resolvedEntityId);
        final encodedType = Uri.encodeComponent(postType);
        router.push(
          '/post/$encodedId?postType=$encodedType',
          extra: targetCommentId.isEmpty
              ? null
              : {'commentId': targetCommentId},
        );
      }
    });
  });

  // Now that the router + listener are ready, handle cold-start notification (if any).
  await fcmService.handleInitialNotificationIfAny();

  // Now start deep link listener - refreshStream is available
  SupabaseService.authService.startDeepLinkListener();

  // Listen to content deep links (posts, stories, videos)
  SupabaseService.authService.contentDeepLinkStream.listen((route) {
    talker.debug('[Main] Content deep link route received: $route');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routePath = route.toRoutePath();
      talker.info('[Main] Navigating to content via deep link: $routePath');
      router.push(routePath);
    });
  });

  // Initialize notification count cubit if user is authenticated
  final notificationCountCubit = getIt<NotificationCountCubit>();

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(storage: storage)..loadSavedTheme(),
          ),
          BlocProvider<NotificationCountCubit>.value(
            value: notificationCountCubit,
          ),
          BlocProvider<PilgrimageBloc>(
            create: (context) => PilgrimageBloc()..add(const LoadJourneyData()),
          ),
        ],
        child: MyItihas(router: router),
      ),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 3), () {
      unawaited(() async {
        try {
          await MyItihasRepository.instance.initialize();
          talker.info('Brick repository initialized');

          try {
            await MyItihasRepository.instance.clearOfflineQueue();
            talker.info('Offline queue cleared');
          } catch (e) {
            talker.warning('Failed to clear offline queue: $e');
          }
        } catch (e, stackTrace) {
          talker.error('Brick repository bootstrap failed', e, stackTrace);
        }

        try {
          await fcmService.initializeTapHandlers();
        } catch (e, stackTrace) {
          talker.error('FCM tap handler initialization failed', e, stackTrace);
        }

        final realtimeService = getIt<RealtimeService>();
        realtimeService.initialize();
        talker.info('RealtimeService initialized');

        if (SupabaseService.client.auth.currentUser != null) {
          unawaited(initializeFcmForCurrentUser('startup session'));
          notificationCountCubit.initialize();
        }
      }());
    });
  });
}

class MyItihas extends StatelessWidget {
  final GoRouter router;

  const MyItihas({super.key, required this.router});

  /// Returns a locale that Flutter's built-in localization delegates can load.
  ///
  /// App translations (via `TranslationProvider`) may support more languages
  /// than `GlobalMaterialLocalizations`. For those cases (e.g. Sanskrit), we
  /// keep app strings in the selected language but fall back framework locale
  /// to a close supported locale to avoid runtime localization failures.
  Locale _safeFrameworkLocale(Locale appLocale) {
    bool isSupportedByAllDelegates(Locale locale) {
      return GlobalMaterialLocalizations.delegate.isSupported(locale) &&
          GlobalWidgetsLocalizations.delegate.isSupported(locale) &&
          GlobalCupertinoLocalizations.delegate.isSupported(locale);
    }

    if (isSupportedByAllDelegates(appLocale)) {
      return appLocale;
    }

    final languageOnly = Locale(appLocale.languageCode);
    if (isSupportedByAllDelegates(languageOnly)) {
      return languageOnly;
    }

    if (appLocale.languageCode == AppLocale.sa.languageCode) {
      return const Locale('hi');
    }

    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Initialize Sizer here
        return Sizer(
          builder: (context, orientation, deviceType) {
            return BlocProvider(
              create: (context) =>
                  getIt<ConnectivityBloc>()
                    ..add(const ConnectivityEvent.checkConnectivity()),
              child: Builder(
                builder: (context) {
                  return BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      final appLocale = TranslationProvider.of(
                        context,
                      ).flutterLocale;
                      return MaterialApp.router(
                        title: 'MyItihas',
                        debugShowCheckedModeBanner: false,

                        locale: _safeFrameworkLocale(appLocale),
                        supportedLocales: AppLocaleUtils.supportedLocales,
                        localizationsDelegates: const [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],

                        themeMode: state.followSystem
                            ? ThemeMode.system
                            : (state.isDark ? ThemeMode.dark : ThemeMode.light),
                        theme: AppTheme.lightTheme,
                        darkTheme: AppTheme.darkTheme,

                        routerConfig: router,

                        builder: (context, child) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              const Positioned.fill(child: GlassBackground()),
                              // top: false and bottom: false so tab content and nav bar extend
                              // to the screen edge; individual screens/nav bar handle safe area.
                              EdgeSwipeBackWrapper(
                                onBack: () {
                                  unawaited(
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).maybePop(),
                                  );
                                },
                                child: SafeArea(
                                  top: false,
                                  bottom: false,
                                  child: child!,
                                ),
                              ),
                              const OfflineBanner(),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
