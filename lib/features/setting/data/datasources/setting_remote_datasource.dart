import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/features/setting/data/models/spotify_connection_model.dart';

abstract class SettingRemoteDataSource {
  Future<SpotifyConnectionModel> createSpotifyConnection({
    required String accessToken,
    required String accessTokenSpotify,
    required String refreshToken,
    required int expiresIn,
  });
  Future<SpotifyConnectionModel?> getSpotifyConnection({
    required String accessToken,
  });
  Future<bool> deleteSpotifyConnection({
    required String accessToken,
  });
}

@LazySingleton(as: SettingRemoteDataSource)
class SettingRemoteDataSourceImpl implements SettingRemoteDataSource {
  final Dio _dio;
  SettingRemoteDataSourceImpl(this._dio);

  @override
  Future<SpotifyConnectionModel> createSpotifyConnection({
    required String accessToken,
    required String accessTokenSpotify,
    required String refreshToken,
    required int expiresIn,
  }) async {
    log('Creating spotify connection...');
    log('accessToken: $accessToken');
    log('accessTokenSpotify: $accessTokenSpotify');
    log('refreshToken: $refreshToken');
    log('expiresIn: $expiresIn');
    try {
      final response = await _dio.post(
        spotifyConnectionUrl,
        data: {
          "accessToken": accessTokenSpotify,
          "refreshToken": refreshToken,
          "spotifyDeviceId": "1234",
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Spotify connection response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 201) {
        return SpotifyConnectionModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        log('Authentication failed: ${response.data}');
        throw UnauthorizedException('Invalid or expired access token');
      } else {
        log('Server error: ${response.data}');
        throw ServerException(
            message: response.data['message'] ?? 'Unknown error occurred');
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Invalid or expired access token');
      }
      throw Exception(e.toString());
    } catch (e) {
      log('Unexpected error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  @override
  Future<SpotifyConnectionModel?> getSpotifyConnection({
    required String accessToken,
  }) async {
    try {
      final response = await _dio.get(
        spotifyConnectionUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return SpotifyConnectionModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        // throw Exception('Spotify connection not found');
        return null;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> deleteSpotifyConnection({
    required String accessToken,
  }) async {
    try {
      final response = await _dio.delete(
        spotifyConnectionUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
