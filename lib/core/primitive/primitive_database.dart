import 'package:mobile_pihome/core/primitive/primitive_keys.dart';

abstract class PrimitiveDataBase {
  Future<T?> read<T>(PrimitiveKeys key);
  Future<bool> write<T>(PrimitiveKeys key, {required T data});
  Future<bool> delete(PrimitiveKeys key);
}
