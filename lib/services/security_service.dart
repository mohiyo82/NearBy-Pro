import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  // Create storage
  static const _storage = FlutterSecureStorage();

  // Save sensitive data
  static Future<void> saveToken(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // Read sensitive data
  static Future<String?> getToken(String key) async {
    return await _storage.read(
      key: key,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // Delete sensitive data
  static Future<void> deleteToken(String key) async {
    await _storage.delete(
      key: key,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // Clear all storage (on logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll(
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
  }
}
