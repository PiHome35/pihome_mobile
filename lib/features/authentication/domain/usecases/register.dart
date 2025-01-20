import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/token.dart';
import '../repositories/auth_repositories.dart';

class RegisterParams {
  final String email;
  final String password;
  final String name;

  RegisterParams(
      {required this.email, required this.password, required this.name});
}

@injectable
class RegisterUseCase
    implements UseCase<DataState<TokenResponseEntity>, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<DataState<TokenResponseEntity>> execute(RegisterParams params) async {
    return await repository.registerUser(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
