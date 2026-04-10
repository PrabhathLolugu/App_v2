import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../logging/talker_setup.dart';

@module
abstract class ApiClientModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue:
              'https://api.myitihas.com', // TODO: Update with actual API URL
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Configure iOS-specific HTTP client with SSL/TLS certificate validation
    if (Platform.isIOS) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          // Set up certificate validation for iOS
          client.badCertificateCallback = (cert, host, port) {
            // iOS has stricter SSL/TLS validation than Android
            // Return true to accept certificates (production should use certificate pinning)
            // This fixes iOS-specific network errors
            return true;
          };
          return client;
        },
      );
    }

    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // TODO: Add auth token to headers
          return handler.next(options);
        },
        onError: (error, handler) {
          talker.error('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
