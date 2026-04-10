import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter/foundation.dart';

late final Talker talker;

void initTalker() {
  talker = TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: true,
      useConsoleLogs: kDebugMode,
      useHistory: true,
      maxHistoryItems: 1000,
    ),
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(
        enableColors: true,
        level: kDebugMode ? LogLevel.verbose : LogLevel.error,
      ),
    ),
  );

  talker.info('Talker logging system initialized');
}

String _truncate(Object? obj, {int maxLines = 3}) {
  final str = obj.toString();
  final lines = str.split('\n');
  if (lines.length <= maxLines) return str;
  return '${lines.take(maxLines).join('\n')}\n...';
}

class _TruncatedBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    talker.log('${bloc.runtimeType} Event: ${_truncate(event)}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    talker.log(
      '${bloc.runtimeType} Change:\n'
      '  current: ${_truncate(change.currentState)}\n'
      '  next: ${_truncate(change.nextState)}',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    talker.log(
      '${bloc.runtimeType} Transition:\n'
      '  event: ${_truncate(transition.event)}\n'
      '  current: ${_truncate(transition.currentState)}\n'
      '  next: ${_truncate(transition.nextState)}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    talker.error('${bloc.runtimeType} Error: ${_truncate(error)}', error, stackTrace);
  }
}

BlocObserver createBlocObserver() => _TruncatedBlocObserver();
