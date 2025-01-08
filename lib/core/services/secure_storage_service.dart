import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:injectable/injectable.dart';

// @lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  static const String keyAccessToken = 'access_token';

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: keyAccessToken);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: keyAccessToken);
  }
}
