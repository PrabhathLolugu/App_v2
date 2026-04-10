import 'package:myitihas/pages/map2/custom_site/custom_site_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SacredSitePolicyException implements Exception {
  final String message;
  final String? reason;

  SacredSitePolicyException(this.message, {this.reason});

  @override
  String toString() => message;
}

class CustomSiteGenerationService {
  CustomSiteGenerationService._();

  static final _supabase = Supabase.instance.client;

  static Future<CustomSiteGenerationResult> generate({
    required String templeName,
    required String locationText,
    double? latitude,
    double? longitude,
    String? userContext,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Please login to create custom sacred sites.');
    }

    try {
      final response = await _supabase.functions.invoke(
        'generate-custom-site-details',
        body: {
          'templeName': templeName,
          'locationText': locationText,
          'latitude': latitude,
          'longitude': longitude,
          'userContext': userContext,
          'language': 'English',
          'userId': userId,
        },
      );

      final data = response.data != null
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};

      if (data['error'] != null) {
        final errorMsg = data['error'].toString();
        final details = data['details'] as Map?;
        if (details != null && details['type'] == 'POLICY_VIOLATION') {
          throw SacredSitePolicyException(
            errorMsg,
            reason: details['reason']?.toString(),
          );
        }
        throw Exception(errorMsg);
      }

      if (response.data == null) {
        throw Exception('No response from generation service.');
      }

      return CustomSiteGenerationResult.fromResponse(data);
    } on FunctionException catch (e) {
      // Supabase invoke might throw FunctionException for non-200 status
      if (e.details is Map) {
        final detailsMap = e.details as Map;
        final errorMsg = detailsMap['error']?.toString() ?? e.toString();
        final detailsObj = detailsMap['details'] as Map?;
        if (detailsObj != null && detailsObj['type'] == 'POLICY_VIOLATION') {
          throw SacredSitePolicyException(
            errorMsg,
            reason: detailsObj['reason']?.toString(),
          );
        }
        throw Exception(errorMsg);
      }
      rethrow;
    }
  }
}
