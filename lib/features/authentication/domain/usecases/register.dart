import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import '../repositories/auth_repositories.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<DataState<void>> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await repository.registerUser(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
