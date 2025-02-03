import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/repositories/auth_repositories.dart';

@injectable
class GetStorageTokenUseCase implements UseCase<String, void> {
  final AuthRepository _authRepository;

  GetStorageTokenUseCase(this._authRepository);

  @override
  Future<String> execute([void params]) async {
    return await _authRepository.getStorageToken();
  }
}
