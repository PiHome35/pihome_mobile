import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/token.dart';

abstract class AuthRepository {
  Future<DataState<TokenResponseEntity>> getToken(
      {required String email, required String password});

  Future<DataState<bool>> checkAuth();
  Future<void> storageToken(String token);
  Future<DataState<void>> registerUser(
      {required String email,
      required String password,
      required String fullName});
}
