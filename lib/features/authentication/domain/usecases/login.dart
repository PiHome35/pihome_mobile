import 'package:injectable/injectable.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repositories.dart';

@injectable
class LoginUseCase implements UseCase<DataState<void>, LoginParams> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<DataState<void>> execute(LoginParams params) {
    return _authRepository.getToken(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
