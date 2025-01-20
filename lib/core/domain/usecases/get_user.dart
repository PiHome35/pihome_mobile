import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/core/domain/repositories/user_repository.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';

@LazySingleton()
class GetUserUseCase implements UseCase<DataState<UserEntity>, String> {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity>> execute(String token) async {
    return await _userRepository.getUser(token: token);
  }
}