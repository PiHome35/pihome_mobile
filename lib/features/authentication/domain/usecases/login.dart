import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/token.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repositories.dart';

@injectable
class LoginUseCase implements UseCase<DataState<TokenResponseEntity>, LoginParams> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<DataState<TokenResponseEntity>> execute(LoginParams params) {
    return _authRepository.login(
      email: params.email,
      password: params.password,
      accessToken: params.accessToken,
    );
  }
}

class LoginParams {
  final String email;
  final String password;
  final String accessToken;

  LoginParams({
    required this.email,
    required this.password,
    required this.accessToken,
  });
}
