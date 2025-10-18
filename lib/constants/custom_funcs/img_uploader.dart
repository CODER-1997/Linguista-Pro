import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageUploader {
  final _picker = ImagePicker();
  RxBool isUploading = false.obs;
  RxBool isLoading = false
      .obs; // ✅ New observable bool to track overall loading status

  /// Upload image for specific teacher document
  Future<void> uploadTeacherImage(String teacherId) async {
    isUploading.value = true;
    isLoading.value = true; // ✅ start loading

    try {
      // Step 1: Pick image
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (picked == null) {
        isUploading.value = false;
        isLoading.value = false;
        return;
      }

      File imageFile = File(picked.path);

      // Step 2: Upload to ImageKit
      final imageUrl = await _uploadToImageKit(imageFile);

      if (imageUrl == null) {
        print("❌ Image upload failed");
        isUploading.value = false;
        isLoading.value = false;
        return;
      }

      // Step 3: Save real ImageKit URL to Firestore
      await FirebaseFirestore.instance
          .collection('LinguistaTeachers')
          .doc(teacherId)
          .update({
        'items.imgUrl': imageUrl,
        'items.updatedAt': FieldValue.serverTimestamp(),
      });

      print("✅ Image uploaded to ImageKit and saved to Firestore!");
    } catch (e) {
      print("⚠️ Error: $e");
    } finally {
      isUploading.value = false;
      isLoading.value = false; // ✅ stop loading in all cases
    }
  }

  /// Uploads file to ImageKit.io and returns the uploaded image URL
  Future<String?> _uploadToImageKit(File imageFile) async {
    const uploadUrl = 'https://upload.imagekit.io/api/v1/files/upload';
    const privateKey = 'private_pgXifnlwHfSGijLvH4soF2xZWlU='; // your private key

    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['fileName'] = imageFile.path.split('/').last
        ..fields['folder'] = '/teachers'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      // Basic Auth header using private key
      request.headers['Authorization'] =
      'Basic ${base64Encode(utf8.encode('$privateKey:'))}';

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        final imageUrl = data['url']; // ✅ real hosted URL from ImageKit
        print("✅ Uploaded Image URL: $imageUrl");
        return imageUrl;
      } else {
        print("❌ Upload failed: ${response.statusCode}, $resBody");
        return null;
      }
    } catch (e) {
      print("⚠️ Upload error: $e");
      return null;
    }
  }
}
