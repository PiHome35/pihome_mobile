import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/core/domain/repositories/user_repository.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';

@LazySingleton()
class CacheUserUseCase implements UseCase<void, UserEntity> {
  final UserRepository _userRepository;
  CacheUserUseCase(this._userRepository);
  
  @override
  Future<void> execute(UserEntity params) async {
    await _userRepository.cacheUser(params);
  }
}
