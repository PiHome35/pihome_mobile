import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/services/secure_storage_service.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  SecureStorageService get secureStorage => SecureStorageService();
}
