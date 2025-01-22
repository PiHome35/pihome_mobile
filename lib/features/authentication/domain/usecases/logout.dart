import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/authentication/data/data_sources/token_local_datasource.dart';

@injectable
class LogoutUseCase implements UseCase<void, NoParams> {
  final TokenLocalDataSource _tokenLocalDataSource;

  LogoutUseCase(this._tokenLocalDataSource);

  @override
  Future<void> execute(NoParams params) async {
    await _tokenLocalDataSource.deleteToken();
  }
}
