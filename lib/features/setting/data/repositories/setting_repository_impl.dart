import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/services/spotify_auth_service.dart';
import 'package:mobile_pihome/features/setting/data/datasources/setting_local_datasource.dart';
import 'package:mobile_pihome/features/setting/data/datasources/setting_remote_datasource.dart';
import 'package:mobile_pihome/features/setting/data/models/setting_model.dart';
import 'package:mobile_pihome/features/setting/data/models/spotify_connection_model.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/entities/spotify_connection_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';

@LazySingleton(as: SettingRepository)
class SettingRepositoryImpl implements SettingRepository {
  final SpotifyAuthService _spotifyAuthService;
  final SettingRemoteDataSource _settingRemoteDataSource;
  final SettingLocalDataSource _settingLocalDataSource;

  SettingRepositoryImpl(
    this._spotifyAuthService,
    this._settingRemoteDataSource,
    this._settingLocalDataSource,
  );

  @override
  Future<Map<String, dynamic>?> connectSpotifyAccount() async {
    return await _spotifyAuthService.authenticate();
  }

  @override
  Future<void> logoutSpotifyConnect() async {
    try {
      await _spotifyAuthService.logout();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DataState<SpotifyConnectionEntity>> createSpotifyConnection({
    required String accessToken,
  }) async {
    try {
      final resultAuth = await _spotifyAuthService.authenticate();

      if (resultAuth == null) {
        return DataFailed(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Authentication failed',
          ),
        );
      }

      final expiresInSeconds = resultAuth['expiresIn'] as int;
      final expiresAtTimestamp =
          DateTime.now().millisecondsSinceEpoch + (expiresInSeconds * 1000);

      final result = await _settingRemoteDataSource.createSpotifyConnection(
        accessTokenSpotify: resultAuth['accessToken'],
        accessToken: accessToken,
        refreshToken: resultAuth['refreshToken'],
        expiresIn: expiresAtTimestamp,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
        ),
      );
    }
  }

  @override
  Future<DataState<SpotifyConnectionEntity?>> getSpotifyConnection({
    required String accessToken,
  }) async {
    try {
      final result = await _settingRemoteDataSource.getSpotifyConnection(
        accessToken: accessToken,
      );
      if (result == null) {
        return const DataSuccess(null);
      }
      return DataSuccess(result);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> cacheSetting(SettingEntity setting) async {
    final SettingModel settingModel = setting.toModel();
    await _settingLocalDataSource.cachedSetting(settingModel);
  }

  @override
  Future<SettingEntity> getCachedSetting() async {
    final SettingModel? settingModel =
        await _settingLocalDataSource.getCachedSetting();
    if (settingModel == null) {
      throw Exception('Setting not found');
    }
    final SettingEntity settingEntity = settingModel.toEntity();
    return settingEntity;
  }

  @override
  Future<SettingEntity> updateCachedSetting(SettingEntity setting) async {
    final SettingModel settingModel = setting.toModel();
    await _settingLocalDataSource.cachedSetting(settingModel);
    return setting;
  }
}
