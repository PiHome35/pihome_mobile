import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/primitive/primitive_keys.dart';
import 'package:mobile_pihome/core/services/secure_storage_service.dart';

class SpotifyAuthService {
  static const String clientId = 'a83d31c161dc4da8af344e5e3ad71785';
  static const String clientSecret = 'ad8f45c37b54454e8365b9f5dc28c5b7';
  static const String redirectUri = 'pihome://callback';
  static const String customUriScheme = 'pihome';
  static const String tokenEndpoint = 'https://accounts.spotify.com/api/token';

  static const String scope =
      'app-remote-control user-modify-playback-state playlist-read-private user-read-playback-state';

  final SecureStorageService _secureStorage;
  final _dio = Dio();

  SpotifyAuthService(this._secureStorage);

  Future<void> initialize() async {
    // No initialization needed
  }

  Future<bool> authenticate() async {
    try {
      final authUri = Uri.https(
        'accounts.spotify.com',
        '/authorize',
        {
          'response_type': 'code',
          'client_id': clientId,
          'scope': scope,
          'redirect_uri': redirectUri,
        },
      );

      developer.log('Starting Spotify authentication...');

      final result = await FlutterWebAuth2.authenticate(
        url: authUri.toString(),
        callbackUrlScheme: customUriScheme,
      );

      final code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        developer.log('Got authorization code: $code');
        return await _exchangeCodeForTokens(code);
      }

      developer.log('No authorization code received');
      return false;
    } catch (e) {
      developer.log('Error during Spotify authentication: $e');
      return false;
    }
  }

  Future<bool> _exchangeCodeForTokens(String code) async {
    try {
      final basicAuth = base64.encode(
        utf8.encode('$clientId:$clientSecret'),
      );

      final response = await _dio.post(
        tokenEndpoint,
        data: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
        options: Options(
          headers: {
            'Authorization': 'Basic $basicAuth',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        final tokens = response.data;
        developer.log('Tokens: ${response.data}');
        await _secureStorage.write(
          PrimitiveKeys.accessTokenSpotify,
          data: tokens['access_token'],
        );
        await _secureStorage.write(
          PrimitiveKeys.refreshTokenSpotify,
          data: tokens['refresh_token'],
        );
        return true;
      }
      return false;
    } catch (e) {
      developer.log('Error exchanging code for tokens: $e');
      return false;
    }
  }

  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final basicAuth = base64.encode(
        utf8.encode('$clientId:$clientSecret'),
      );

      final response = await _dio.post(
        tokenEndpoint,
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(
          headers: {
            'Authorization': 'Basic $basicAuth',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        final tokens = response.data;
        await _secureStorage.write(
          PrimitiveKeys.accessTokenSpotify,
          data: tokens['access_token'],
        );
        await _secureStorage.write(
          PrimitiveKeys.refreshTokenSpotify,
          data: tokens['refresh_token'],
        );
        // Some implementations also return a new refresh token
        if (tokens['refresh_token'] != null) {
          await _secureStorage.write(
            PrimitiveKeys.refreshTokenSpotify,
            data: tokens['refresh_token'],
          );
        }
        return tokens['access_token'];
      }
      return null;
    } catch (e) {
      developer.log('Error refreshing token: $e');
      return null;
    }
  }

  Future<String?> getValidAccessToken() async {
    try {
      final accessToken = await _secureStorage.read(PrimitiveKeys.accessTokenSpotify);
      final refreshToken = await _secureStorage.read(PrimitiveKeys.refreshTokenSpotify);
      final expiryString = await _secureStorage.read(PrimitiveKeys.refreshTokenSpotify);

      if (accessToken == null || refreshToken == null || expiryString == null) {
        return null;
      }

      final expiry = DateTime.parse(expiryString);
      if (DateTime.now().isBefore(expiry)) {
        return accessToken;
      }

      // Token is expired, try to refresh it
      return await _refreshAccessToken(refreshToken);
    } catch (e) {
      developer.log('Error getting valid access token: $e');
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await getValidAccessToken();
    return token != null;
  }

  Future<void> logout() async {
    try {
      await _secureStorage.delete(PrimitiveKeys.accessTokenSpotify);
      await _secureStorage.delete(PrimitiveKeys.refreshTokenSpotify);
      developer.log('Spotify logout successful');
    } catch (e) {
      developer.log('Error during Spotify logout: $e');
    }
  }

  void dispose() {
    // No cleanup needed
  }
}
