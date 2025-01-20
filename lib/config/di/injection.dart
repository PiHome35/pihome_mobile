import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies(String environment) {
  getIt.init(environment: environment);
}

class Injectable {
  void initialize([String env = 'dev']) => configureDependencies(env);
}
