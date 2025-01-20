import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/graphql/graphql_config.dart';
import 'package:mobile_pihome/core/services/spotify_auth_service.dart';
import 'package:mobile_pihome/core/utils/cache/hive_manager.dart';
import 'package:mobile_pihome/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_local_datasource.dart';

import '../../core/services/secure_storage_service.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  SecureStorageService get secureStorage =>
      SecureStorageService(const FlutterSecureStorage());

  @lazySingleton
  SpotifyAuthService get spotifyAuthService =>
      SpotifyAuthService(secureStorage);

  @lazySingleton
  HiveManager get hiveManager => HiveManager();

  @LazySingleton(as: DeviceLocalDataSource)
  DeviceLocalDataSourceImpl get deviceLocalDataSource =>
      DeviceLocalDataSourceImpl(hiveManager);

  @LazySingleton(as: IChatRemoteDataSource)
  ChatRemoteDataSource get chatRemoteDataSource =>
      ChatRemoteDataSource(GraphQLConfig());
}
