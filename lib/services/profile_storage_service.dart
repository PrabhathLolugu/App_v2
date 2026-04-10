import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/core/di/injection_container.dart';

/// Service for managing profile photo uploads to Supabase Storage
@lazySingleton
class ProfileStorageService {
  static const String _bucketName = 'profile-avatars';  // Back to hyphen
  static const int _maxImageSize = 1024; // Max width/height in pixels
  static const int _compressionQuality = 85; // 0-100

  final SupabaseClient _supabase;

  ProfileStorageService(this._supabase);

  /// Uploads a profile photo to Supabase Storage and returns the public URL
  /// 
  /// - Compresses image to max 1024x1024, 85% quality
  /// - Uploads to: profile-avatars/{userId}/avatar.jpg
  /// - Uses upsert=true to overwrite existing file
  /// - Returns public URL on success
  /// - Throws exception on failure
  Future<String> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    final logger = getIt<Talker>();
    logger.info('📸 Starting profile photo upload for user: $userId');
    
    try {
      // Validate authenticated user matches userId (security check)
      final currentUser = SupabaseService.authService.getCurrentUser();
      logger.debug('Current user from auth: ${currentUser?.id}');
      
      if (currentUser == null || currentUser.id != userId) {
        logger.error('❌ Authorization failed: currentUser=${currentUser?.id}, targetUser=$userId');
        throw Exception('Unauthorized: User can only upload their own avatar');
      }
      logger.info('✅ User authorized to upload');

      // Compress image before upload to optimize storage and bandwidth
      logger.info('🗜️ Compressing image...');
      final compressedFile = await _compressImage(imageFile);
      final fileSize = await compressedFile.length();
      logger.info('✅ Image compressed successfully. Size: ${fileSize / 1024} KB');

      // Define storage path: {userId}/avatar.jpg
      final String storagePath = '$userId/avatar.jpg';
      logger.debug('Storage path: $storagePath');

      // Upload to Supabase Storage with upsert (overwrite existing)
      logger.info('☁️ Uploading to Supabase Storage bucket: $_bucketName');
      await _supabase.storage.from(_bucketName).uploadBinary(
            storagePath,
            await compressedFile.readAsBytes(),
            fileOptions: const FileOptions(
              upsert: true, // Overwrite if exists
              contentType: 'image/jpeg',
            ),
          );
      logger.info('✅ Upload successful');

      // Get public URL for the uploaded image
      final String baseUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(storagePath);
      
      // Add timestamp to bust cache (same URL path but different query param)
      final String publicUrl = '$baseUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      logger.info('🔗 Public URL generated: $publicUrl');

      // Clean up temporary compressed file
      await _deleteTemporaryFile(compressedFile);
      logger.info('🧹 Temporary file cleaned up');

      logger.info('✅ Profile photo upload completed successfully');
      return publicUrl;
    } catch (e) {
      logger.error('❌ Profile photo upload failed', e);
      throw Exception('Failed to upload profile photo: ${e.toString()}');
    }
  }

  /// Compresses image to optimize file size and dimensions
  /// 
  /// - Reduces to max 1024x1024 while maintaining aspect ratio
  /// - Compresses to JPEG at 85% quality
  /// - Saves to temporary directory
  Future<File> _compressImage(File imageFile) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: _compressionQuality,
        minWidth: _maxImageSize,
        minHeight: _maxImageSize,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        throw Exception('Image compression failed');
      }

      return File(compressedFile.path);
    } catch (e) {
      // If compression fails, use original file
      return imageFile;
    }
  }

  /// Clean up temporary compressed file
  Future<void> _deleteTemporaryFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Generates a timestamped URL to bypass browser cache
  /// 
  /// Useful when avatar is updated but URL path stays the same
  String getCacheBypassUrl(String publicUrl) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$publicUrl?t=$timestamp';
  }
}
