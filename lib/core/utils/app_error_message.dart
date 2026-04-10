import 'dart:io';

import 'package:myitihas/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String kConnectToInternetMessage = 'Connect to internet and try again.';

String toUserFriendlyErrorMessage(
  Object error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is NetworkException) {
    return kConnectToInternetMessage;
  }
  if (error is SocketException ||
      error is HttpException ||
      error is TlsException ||
      error is HandshakeException) {
    return kConnectToInternetMessage;
  }
  if (error is PostgrestException) {
    final message = error.message.toLowerCase();
    if (message.contains('failed host lookup') ||
        message.contains('socket') ||
        message.contains('network') ||
        message.contains('offline') ||
        message.contains('connection')) {
      return kConnectToInternetMessage;
    }
    return fallback;
  }
  if (error is FunctionException) {
    if (error.status == 400 || error.status == 500) {
      return 'Servers are busy. Please try again later.';
    }
    final details = '${error.reasonPhrase ?? ''} ${error.details ?? ''}'
        .toLowerCase();
    if (details.contains('failed host lookup') ||
        details.contains('network') ||
        details.contains('offline') ||
        details.contains('connection') ||
        details.contains('socket')) {
      return kConnectToInternetMessage;
    }
    return fallback;
  }
  if (error is AppException) {
    if (error is ServerException) {
      if (error.code == '400' || error.code == '500') {
        return 'Servers are busy. Please try again later.';
      }
    }
    final message = error.message.toLowerCase();
    if (message.contains('internet') ||
        message.contains('network') ||
        message.contains('connection')) {
      return kConnectToInternetMessage;
    }
    return error.message;
  }
  final raw = error.toString().toLowerCase();
  if (raw.contains('failed host lookup') ||
      raw.contains('socket') ||
      raw.contains('network') ||
      raw.contains('offline') ||
      raw.contains('connection')) {
    return kConnectToInternetMessage;
  }
  return fallback;
}
