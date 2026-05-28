import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String> uploadImage(String path, String fileName) async {
    final ref = _storage.ref().child('images/$fileName');
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }

  Future<String> uploadFile(String path, String fileName) async {
    final ref = _storage.ref().child('files/$fileName');
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> captureImage() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  Future<XFile?> pickFile() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {}
  }

  // Local cache
  Future<void> cacheData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
