import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ImgbbService {
  static const String _apiKey = '6060584b6370f78603d7aac34cbfd5bf';
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final dio = Dio();

      final formData = FormData.fromMap({
        'key': _apiKey,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await dio.post(_uploadUrl, data: formData);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final String imageUrl = response.data['data']['url'];
        debugPrint('Upload ImgBB Sukses: $imageUrl');
        return imageUrl;
      }
      return null;
    } catch (e) {
      debugPrint('Error Upload ImgBB: $e');
      return null;
    }
  }
}
