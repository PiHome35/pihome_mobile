import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_pihome/core/primitive/primitive_database.dart';
import 'package:mobile_pihome/core/primitive/primitive_keys.dart';

class SecureStorageService extends PrimitiveDataBase {
  final FlutterSecureStorage _storage;
  SecureStorageService(this._storage);

  @override
  Future<bool> delete(PrimitiveKeys key) async {
    try {
      await _storage.delete(key: key.name);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<T?> read<T>(PrimitiveKeys key) async {
    final response = await _storage.read(key: key.name);
    if (response == null) {
      return null;
    }
    return response.tryParse<T>();
  }

  @override
  Future<bool> write<T>(PrimitiveKeys key, {required T data}) async {
    try {
      await _storage.write(
        key: key.name,
        value: data.toString(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

extension StringExtension on String {
  T? tryParse<T>() {
    try {
      return switch (T) {
        const (int) => int.parse(this) as T,
        const (double) => double.parse(this) as T,
        const (bool) => (toLowerCase() == 'true') as T,
        const (String) => this as T,
        _ => null,
      };
    } catch (e) {
      return null;
    }
  }
}
