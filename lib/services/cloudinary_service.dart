import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';

class CloudinaryService {
  // Replace with your actual Cloudinary details from the screenshot
  static const String _cloudName = 'dapsxeewd';
  static const String _uploadPreset = 'unsigned_uploads';

  final _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);

  /// Uploads an image to Cloudinary and returns the Secure URL.
  Future<String?> uploadImage(File file) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'user_profiles', // Optional: organized folder in Cloudinary
        ),
      );
      return response.secureUrl;
    } catch (e) {
      debugPrint("Cloudinary Upload Error: $e");
      return null;
    }
  }
}
