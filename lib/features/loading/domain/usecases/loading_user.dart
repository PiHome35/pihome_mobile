import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/core/domain/repositories/user_repository.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';

@injectable
class LoadingUserUsecase implements UseCase<DataState<UserEntity>, String> {
  final UserRepository _userRepository;
  LoadingUserUsecase(this._userRepository);

  @override
  Future<DataState<UserEntity>> execute(String token) {
    return _userRepository.getUser(token: token);
  }
}
