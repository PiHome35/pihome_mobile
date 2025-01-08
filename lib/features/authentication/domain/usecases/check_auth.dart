import 'package:injectable/injectable.dart';

import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/repositories/auth_repositories.dart';

@injectable
class CheckAuthUseCase implements UseCase<DataState<bool>, void> {
  final AuthRepository _authRepository;

  CheckAuthUseCase(this._authRepository);

  @override
  Future<DataState<bool>> execute([void params]) {
    return _authRepository.checkAuth();
  }
}
