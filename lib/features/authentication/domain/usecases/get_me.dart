import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/domain/entities/auth_user.dart';
import 'package:mobile_pihome/features/authentication/domain/repositories/auth_repositories.dart';

@injectable
class GetMeUseCase implements UseCase<DataState<AuthUserEntity>, String> {
  final AuthRepository _authRepository;

  GetMeUseCase(this._authRepository);

  @override
  Future<DataState<AuthUserEntity>> execute(String params) {
    return _authRepository.getMe(
      accessToken: params,
    );
  }
}
