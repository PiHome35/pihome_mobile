import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/repositories/auth_repositories.dart';

@injectable
class StorageTokenUseCase implements UseCase<void, String> {
  final AuthRepository _authRepository;

  StorageTokenUseCase(this._authRepository);

  @override
  Future<void> execute(String token) {
    return _authRepository.storageToken(token);
  }
}
