import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';

abstract class UserRepository {
  Future<DataState<UserEntity>> getUser({required String token});
  Future<UserEntity> getCachedUser();
  Future<void> cacheUser(UserEntity user);
}
