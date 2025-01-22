import 'dart:developer';

import 'package:mobile_pihome/core/primitive/primitive_keys.dart';
import 'package:mobile_pihome/core/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TokenLocalDataSource {
  final SecureStorageService _secureStorage;

  TokenLocalDataSource(this._secureStorage);

  Future<String> getToken() async {
    final String? token = await _secureStorage.read(PrimitiveKeys.accessToken);
    log('[get] token: $token');
    if (token == null) {
      throw Exception('Token not found');
    }
    return token;
  }

  Future<void> storageToken(String token) async {
    final bool isSuccess = await _secureStorage.write(PrimitiveKeys.accessToken, data: token);
    if (!isSuccess) {
      throw Exception('Failed to write token to secure storage');
    }
    log('[write] token: $token');
  }

  Future<void> deleteToken() async {
    final bool isSuccess = await _secureStorage.delete(PrimitiveKeys.accessToken);
    if (!isSuccess) {
      throw Exception('Failed to delete token from secure storage');
    }
  }
}
