import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class CloudinaryService {
  late final CloudinaryPublic _cloudinary;

  // TODO: Replace with your Cloudinary credentials
  static const String _cloudName = 'drvgczmup';
  static const String _uploadPreset = 'restaurant_reservation_app';

  CloudinaryService() {
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  /// Upload an image to Cloudinary and return the URL
  /// Compresses the image before uploading to reduce size
  Future<String> uploadImage(
    File imageFile, {
    String folder = 'restaurants',
  }) async {
    try {
      // Verify file exists before attempting upload
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist at path: ${imageFile.path}');
      }

      // Try to compress image before upload, but use original if compression fails
      File fileToUpload = imageFile;
      try {
        final compressedFile = await _compressImage(imageFile);
        if (compressedFile != null && await compressedFile.exists()) {
          fileToUpload = compressedFile;
        }
      } catch (e) {
        // If compression fails, use original file
        fileToUpload = imageFile;
      }

      // Upload to Cloudinary
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          fileToUpload.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      // Clean up compressed file if it was created and is different from original
      if (fileToUpload.path != imageFile.path) {
        try {
          await fileToUpload.delete();
        } catch (e) {
          // Ignore cleanup errors
        }
      }

      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    String folder = 'restaurants',
  }) async {
    final List<String> urls = [];

    for (final file in imageFiles) {
      final url = await uploadImage(file, folder: folder);
      urls.add(url);
    }

    return urls;
  }

  /// Compress image to reduce file size
  Future<File?> _compressImage(File file) async {
    try {
      // Verify source file exists
      if (!await file.exists()) {
        return null;
      }

      final filePath = file.absolute.path;
      
      // Generate output path in the same directory as source
      final directory = file.parent.path;
      final fileName = path.basenameWithoutExtension(filePath);
      final extension = path.extension(filePath);
      final outPath = '$directory/${fileName}_compressed$extension';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (e) {
      // If compression fails, return null (caller will use original)
      return null;
    }
  }

  /// Delete an image from Cloudinary using its public ID
  /// Note: This requires Cloudinary API credentials and HTTP requests
  /// For the unsigned upload preset, deletion should be handled server-side
  Future<void> deleteImage(String publicId) async {
    // Deletion requires signed requests with API credentials
    // This should be implemented with a backend API call
    // For now, just log the intent
    throw UnimplementedError(
      'Image deletion requires server-side implementation with Cloudinary API credentials',
    );
  }

  /// Extract public ID from Cloudinary URL
  String getPublicIdFromUrl(String url) {
    // Example URL: https://res.cloudinary.com/cloud_name/image/upload/v1234567890/restaurants/image_id.jpg
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    // Find the index after 'upload'
    final uploadIndex = pathSegments.indexOf('upload');
    if (uploadIndex == -1 || uploadIndex + 2 >= pathSegments.length) {
      throw Exception('Invalid Cloudinary URL');
    }

    // Get everything after version number (v1234567890)
    final pathAfterVersion = pathSegments.skip(uploadIndex + 2).join('/');

    // Remove file extension
    return pathAfterVersion.replaceAll(RegExp(r'\.[^.]+$'), '');
  }
}
