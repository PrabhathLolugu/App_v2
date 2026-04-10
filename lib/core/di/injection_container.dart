import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/core/network/internet_reachability.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();

@module
abstract class ThirdPartyModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => SupabaseService.client;

  @lazySingleton
  Talker get logger => talker;

  @lazySingleton
  MyItihasRepository get repository => MyItihasRepository.instance;

  @lazySingleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  @lazySingleton
  InternetReachability internetReachability(InternetConnection connection) =>
      InternetReachability.fromConnection(connection);
}
