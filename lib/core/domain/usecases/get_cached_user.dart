import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/data/datasources/local/user_local_datasource.dart';
import 'package:mobile_pihome/core/data/models/user_model.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';

@LazySingleton()
class GetCachedUserUseCase implements UseCase<UserModel, NoParams> {
  final UserLocalDataSource _userLocalDataSource;

  GetCachedUserUseCase(this._userLocalDataSource);

  @override
  Future<UserModel> execute(NoParams params) async {
    return await _userLocalDataSource.getSavedUser();
  }
}
