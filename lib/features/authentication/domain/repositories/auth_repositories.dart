import 'package:mobile_pihome/core/resources/data_state.dart';
// import 'package:mobile_pihome/features/authentication/data/models/auth_user_model.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/auth_user.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/token.dart';

abstract class AuthRepository {
  Future<DataState<TokenResponseEntity>> login({
    required String email,
    required String password,
  });

  Future<DataState<bool>> checkAuth();
  Future<void> storageToken(String token);
  Future<String> getStorageToken();
  Future<DataState<TokenResponseEntity>> registerUser(
      {required String email, required String password, required String name});

  Future<DataState<AuthUserEntity>> getMe({
    required String accessToken,
  });
}
