import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/constants/hive_constant.dart';
import 'package:mobile_pihome/core/data/models/user_model.dart';
import 'package:mobile_pihome/core/utils/cache/hive_manager.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getSavedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> deleteLocalUser();
}

@LazySingleton(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final HiveManager _hiveManager;

  UserLocalDataSourceImpl(this._hiveManager);

  @override
  Future<UserModel> getSavedUser() async {
    try {
      final user = _hiveManager.userBox.get(HiveConstant.userBoxKey);
      if (user == null) {
        throw Exception('User not found');
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<void> deleteLocalUser() async {
    try {
      await _hiveManager.userBox.clear();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _hiveManager.userBox.put(HiveConstant.userBoxKey, user);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
