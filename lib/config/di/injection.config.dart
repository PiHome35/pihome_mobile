// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/services/secure_storage_service.dart' as _i814;
import '../../features/authentication/data/data_sources/auth_remote_datasource.dart'
    as _i539;
import '../../features/authentication/data/repositories/auth_repositories_impl.dart'
    as _i988;
import '../../features/authentication/domain/repositories/auth_repositories.dart'
    as _i1017;
import '../../features/authentication/domain/usecases/check_auth.dart' as _i491;
import '../../features/authentication/domain/usecases/login.dart' as _i831;
import '../../features/authentication/domain/usecases/register.dart' as _i1009;
import '../../features/authentication/domain/usecases/storage_token.dart'
    as _i731;
import '../../features/authentication/presentation/bloc/auth_bloc.dart'
    as _i180;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i814.SecureStorageService>(
        () => registerModule.secureStorage);
    gh.factory<_i539.AuthRemoteDataSource>(
        () => _i539.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.factory<_i1017.AuthRepository>(() => _i988.AuthRepositoryImpl(
          gh<_i539.AuthRemoteDataSource>(),
          gh<_i814.SecureStorageService>(),
        ));
    gh.factory<_i1009.RegisterUseCase>(
        () => _i1009.RegisterUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i831.LoginUseCase>(
        () => _i831.LoginUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i491.CheckAuthUseCase>(
        () => _i491.CheckAuthUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i731.StorageTokenUseCase>(
        () => _i731.StorageTokenUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i180.AuthBloc>(() => _i180.AuthBloc(
          gh<_i831.LoginUseCase>(),
          gh<_i491.CheckAuthUseCase>(),
          gh<_i731.StorageTokenUseCase>(),
          gh<_i1009.RegisterUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
