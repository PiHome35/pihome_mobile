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

import '../../core/data/datasources/local/user_local_datasource.dart' as _i314;
import '../../core/data/datasources/remote/user_remote_datasource.dart'
    as _i115;
import '../../core/data/repositories/user_repository_impl.dart' as _i7;
import '../../core/domain/repositories/user_repository.dart' as _i389;
import '../../core/domain/usecases/cache_user.dart' as _i163;
import '../../core/domain/usecases/get_cached_user.dart' as _i823;
import '../../core/domain/usecases/get_user.dart' as _i297;
import '../../core/presentation/bloc/local/user_local_bloc.dart' as _i613;
import '../../core/services/secure_storage_service.dart' as _i814;
import '../../core/services/spotify_auth_service.dart' as _i545;
import '../../core/utils/cache/hive_manager.dart' as _i720;
import '../../features/authentication/data/data_sources/auth_remote_datasource.dart'
    as _i539;
import '../../features/authentication/data/data_sources/token_local_datasource.dart'
    as _i746;
import '../../features/authentication/data/repositories/auth_repositories_impl.dart'
    as _i988;
import '../../features/authentication/domain/repositories/auth_repositories.dart'
    as _i1017;
import '../../features/authentication/domain/usecases/check_auth.dart' as _i491;
import '../../features/authentication/domain/usecases/get_me.dart' as _i951;
import '../../features/authentication/domain/usecases/get_storage_token.dart'
    as _i295;
import '../../features/authentication/domain/usecases/login.dart' as _i831;
import '../../features/authentication/domain/usecases/logout.dart' as _i943;
import '../../features/authentication/domain/usecases/register.dart' as _i1009;
import '../../features/authentication/domain/usecases/storage_token.dart'
    as _i731;
import '../../features/authentication/presentation/bloc/auth_bloc.dart'
    as _i180;
import '../../features/chat/data/datasources/chat_remote_datasource.dart'
    as _i159;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/chat/domain/usecases/add_message_usecase.dart' as _i724;
import '../../features/chat/domain/usecases/create_new_chat.dart' as _i157;
import '../../features/chat/domain/usecases/get_all_chats.dart' as _i976;
import '../../features/chat/domain/usecases/get_all_chats_usecase.dart'
    as _i1005;
import '../../features/chat/domain/usecases/get_chat_messages_usecase.dart'
    as _i167;
import '../../features/chat/domain/usecases/subscribe_to_messages.dart'
    as _i172;
import '../../features/chat/presentation/bloc/chat_bloc.dart' as _i65;
import '../../features/device/data/datasources/ble_local_datasource.dart'
    as _i102;
import '../../features/device/data/datasources/device_local_datasource.dart'
    as _i563;
import '../../features/device/data/datasources/device_remote_datasource.dart'
    as _i590;
import '../../features/device/data/datasources/mock/device_group_mock_datasource.dart'
    as _i439;
import '../../features/device/data/datasources/mock/device_mock_datasource.dart'
    as _i863;
import '../../features/device/data/repositories/ble_detail_repository_impl.dart'
    as _i528;
import '../../features/device/data/repositories/ble_scan_repository_impl.dart'
    as _i106;
import '../../features/device/data/repositories/bluetooth_repository_impl.dart'
    as _i993;
import '../../features/device/data/repositories/device_group_repository_impl.dart'
    as _i454;
import '../../features/device/data/repositories/device_repository_impl.dart'
    as _i740;
import '../../features/device/domain/repositories/ble_detail_repository.dart'
    as _i476;
import '../../features/device/domain/repositories/ble_scan_repository.dart'
    as _i99;
import '../../features/device/domain/repositories/bluetooth_repository.dart'
    as _i644;
import '../../features/device/domain/repositories/device_repository.dart'
    as _i985;
import '../../features/device/domain/repositories/i_device_group_repository.dart'
    as _i932;
import '../../features/device/domain/usecases/cache_devices.dart' as _i240;
import '../../features/device/domain/usecases/create_device_group.dart'
    as _i675;
import '../../features/device/domain/usecases/delete_device_group.dart'
    as _i350;
import '../../features/device/domain/usecases/fetch_device.dart' as _i498;
import '../../features/device/domain/usecases/get_cache_devices.dart' as _i86;
import '../../features/device/domain/usecases/get_device_group.dart' as _i69;
import '../../features/device/domain/usecases/get_device_groups.dart' as _i53;
import '../../features/device/domain/usecases/update_cached_device.dart'
    as _i775;
import '../../features/device/domain/usecases/update_device_group.dart'
    as _i326;
import '../../features/device/presentation/bloc/device_bloc.dart' as _i1022;
import '../../features/device/presentation/bloc/device_group_bloc.dart'
    as _i918;
import '../../features/device/presentation/bloc/local/ble/ble_scan_bloc.dart'
    as _i786;
import '../../features/device/presentation/bloc/local/ble_detail/ble_detail_bloc.dart'
    as _i278;
import '../../features/device/presentation/bloc/local/bluetooth/bluetooth_bloc.dart'
    as _i891;
import '../../features/device/presentation/bloc/local/device_local_bloc.dart'
    as _i72;
import '../../features/family/data/datasources/family_remote_datasource.dart'
    as _i682;
import '../../features/family/data/repositories/family_repository_impl.dart'
    as _i590;
import '../../features/family/domain/repositories/family_repository.dart'
    as _i797;
import '../../features/family/domain/usecases/create_family.dart' as _i311;
import '../../features/family/domain/usecases/create_invite_code.dart' as _i779;
import '../../features/family/domain/usecases/delete_invite_code.dart' as _i325;
import '../../features/family/domain/usecases/get_family_detail.dart' as _i681;
import '../../features/family/domain/usecases/join_family.dart' as _i677;
import '../../features/family/domain/usecases/list_user_family.dart' as _i315;
import '../../features/family/presentation/bloc/family_bloc.dart' as _i160;
import '../../features/family/presentation/bloc/family_setting/family_setting_bloc.dart'
    as _i411;
import '../../features/landing/presentation/bloc/landing_bloc.dart' as _i876;
import '../../features/loading/domain/usecases/cache_setting.dart' as _i611;
import '../../features/loading/domain/usecases/get_spotify_connect.dart'
    as _i74;
import '../../features/loading/domain/usecases/loading_user.dart' as _i933;
import '../../features/loading/presentation/bloc/loading_remote_bloc.dart'
    as _i111;
import '../../features/setting/data/datasources/setting_local_datasource.dart'
    as _i508;
import '../../features/setting/data/datasources/setting_remote_datasource.dart'
    as _i429;
import '../../features/setting/data/repositories/setting_repository_impl.dart'
    as _i182;
import '../../features/setting/domain/repositories/setting_repository.dart'
    as _i819;
import '../../features/setting/domain/usecases/connect_spotify_account.dart'
    as _i382;
import '../../features/setting/domain/usecases/create_spotify_connection.dart'
    as _i1015;
import '../../features/setting/domain/usecases/get_cache_setting.dart' as _i908;
import '../../features/setting/domain/usecases/logout_spotify_connect.dart'
    as _i643;
import '../../features/setting/presentation/bloc/setting_bloc.dart' as _i941;
import 'register_module.dart' as _i291;

const String _mock = 'mock';
const String _dev = 'dev';

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
    gh.factory<_i876.LandingBloc>(() => _i876.LandingBloc());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i814.SecureStorageService>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i545.SpotifyAuthService>(
        () => registerModule.spotifyAuthService);
    gh.lazySingleton<_i720.HiveManager>(() => registerModule.hiveManager);
    gh.lazySingleton<_i439.DeviceGroupMockDatasource>(
      () => _i439.DeviceGroupMockDataSourceImpl(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i115.UserRemoteDataSource>(
        () => _i115.UserRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i159.IChatRemoteDataSource>(
        () => registerModule.chatRemoteDataSource);
    gh.lazySingleton<_i590.DeviceDatasource>(
      () => _i863.DeviceMockDatasourceImpl(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i539.AuthRemoteDataSource>(
        () => _i539.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i590.DeviceDatasource>(
      () => _i590.DeviceRemoteDatasourceImpl(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i746.TokenLocalDataSource>(
        () => _i746.TokenLocalDataSource(gh<_i814.SecureStorageService>()));
    gh.lazySingleton<_i682.FamilyRemoteDataSource>(
        () => _i682.FamilyRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i429.SettingRemoteDataSource>(
        () => _i429.SettingRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i563.DeviceLocalDataSource>(
        () => registerModule.deviceLocalDataSource);
    gh.lazySingleton<_i476.BleDetailRepository>(
        () => _i528.BleDetailRepositoryImpl());
    gh.lazySingleton<_i644.BluetoothRepository>(
        () => _i993.BluetoothRepositoryImpl());
    gh.factory<_i943.LogoutUseCase>(
        () => _i943.LogoutUseCase(gh<_i746.TokenLocalDataSource>()));
    gh.lazySingleton<_i102.BleLocalDataSource>(
        () => registerModule.bleLocalDataSource);
    gh.lazySingleton<_i985.DeviceRepository>(
      () => _i740.DeviceRepositoryImpl(
        gh<_i590.DeviceDatasource>(),
        gh<_i563.DeviceLocalDataSource>(),
      ),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i314.UserLocalDataSource>(
        () => _i314.UserLocalDataSourceImpl(gh<_i720.HiveManager>()));
    gh.lazySingleton<_i389.UserRepository>(() => _i7.UserRepositoryImpl(
          gh<_i115.UserRemoteDataSource>(),
          gh<_i314.UserLocalDataSource>(),
        ));
    gh.lazySingleton<_i932.IDeviceGroupRepository>(() =>
        _i454.DeviceGroupRepositoryImpl(gh<_i439.DeviceGroupMockDatasource>()));
    gh.factory<_i420.IChatRepository>(
        () => _i504.ChatRepositoryImpl(gh<_i159.IChatRemoteDataSource>()));
    gh.lazySingleton<_i797.FamilyRepository>(
        () => _i590.FamilyRepositoryImpl(gh<_i682.FamilyRemoteDataSource>()));
    gh.lazySingleton<_i99.BleScanRepository>(
        () => _i106.BleScanRepositoryImpl(gh<_i102.BleLocalDataSource>()));
    gh.factory<_i278.BleDetailBloc>(
        () => _i278.BleDetailBloc(gh<_i476.BleDetailRepository>()));
    gh.lazySingleton<_i508.SettingLocalDataSource>(
        () => _i508.SettingLocalDataSourceImpl(gh<_i720.HiveManager>()));
    gh.factory<_i891.BluetoothBloc>(
        () => _i891.BluetoothBloc(gh<_i644.BluetoothRepository>()));
    gh.factory<_i167.GetChatMessagesUseCase>(
        () => _i167.GetChatMessagesUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i1005.GetAllChatsUseCase>(
        () => _i1005.GetAllChatsUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i724.AddMessageUseCase>(
        () => _i724.AddMessageUseCase(gh<_i420.IChatRepository>()));
    gh.lazySingleton<_i823.GetCachedUserUseCase>(
        () => _i823.GetCachedUserUseCase(gh<_i314.UserLocalDataSource>()));
    gh.factory<_i1017.AuthRepository>(() => _i988.AuthRepositoryImpl(
          gh<_i539.AuthRemoteDataSource>(),
          gh<_i746.TokenLocalDataSource>(),
        ));
    gh.factory<_i933.LoadingUserUsecase>(
        () => _i933.LoadingUserUsecase(gh<_i389.UserRepository>()));
    gh.lazySingleton<_i297.GetUserUseCase>(
        () => _i297.GetUserUseCase(gh<_i389.UserRepository>()));
    gh.lazySingleton<_i163.CacheUserUseCase>(
        () => _i163.CacheUserUseCase(gh<_i389.UserRepository>()));
    gh.factory<_i779.CreateInviteCodeUseCase>(
        () => _i779.CreateInviteCodeUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i677.JoinFamilyUseCase>(
        () => _i677.JoinFamilyUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i315.ListUserFamilyUseCase>(
        () => _i315.ListUserFamilyUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i681.GetFamilyDetailUseCase>(
        () => _i681.GetFamilyDetailUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i786.BleScanBloc>(
        () => _i786.BleScanBloc(gh<_i99.BleScanRepository>()));
    gh.factory<_i613.UserLocalBloc>(
        () => _i613.UserLocalBloc(gh<_i823.GetCachedUserUseCase>()));
    gh.lazySingleton<_i819.SettingRepository>(() => _i182.SettingRepositoryImpl(
          gh<_i545.SpotifyAuthService>(),
          gh<_i429.SettingRemoteDataSource>(),
          gh<_i508.SettingLocalDataSource>(),
        ));
    gh.factory<_i498.FetchDeviceUseCase>(
        () => _i498.FetchDeviceUseCase(gh<_i985.DeviceRepository>()));
    gh.lazySingleton<_i775.UpdateCachedDeviceUseCase>(
        () => _i775.UpdateCachedDeviceUseCase(gh<_i985.DeviceRepository>()));
    gh.lazySingleton<_i240.CacheDevicesUseCase>(
        () => _i240.CacheDevicesUseCase(gh<_i985.DeviceRepository>()));
    gh.lazySingleton<_i86.GetCachedDevicesUseCase>(
        () => _i86.GetCachedDevicesUseCase(gh<_i985.DeviceRepository>()));
    gh.factory<_i1015.CreateSpotifyConnectionUseCase>(() =>
        _i1015.CreateSpotifyConnectionUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i643.LogoutSpotifyConnectUseCase>(
        () => _i643.LogoutSpotifyConnectUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i157.CreateNewChatUseCase>(
        () => _i157.CreateNewChatUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i976.GetAllChatsUseCase>(
        () => _i976.GetAllChatsUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i172.SubscribeToMessagesUseCase>(
        () => _i172.SubscribeToMessagesUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i325.DeleteInviteCodeUseCase>(
        () => _i325.DeleteInviteCodeUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i69.GetDeviceGroupUseCase>(
        () => _i69.GetDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i350.DeleteDeviceGroupUseCase>(() =>
        _i350.DeleteDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i53.GetDeviceGroupsUseCase>(
        () => _i53.GetDeviceGroupsUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i326.UpdateDeviceGroupUseCase>(() =>
        _i326.UpdateDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i675.CreateDeviceGroupUseCase>(() =>
        _i675.CreateDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i311.CreateFamilyUseCase>(
        () => _i311.CreateFamilyUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i1009.RegisterUseCase>(
        () => _i1009.RegisterUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i611.CacheSettingUseCase>(
        () => _i611.CacheSettingUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i74.GetSpotifyConnectUseCase>(
        () => _i74.GetSpotifyConnectUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i908.GetCachedSettingUseCase>(
        () => _i908.GetCachedSettingUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i382.ConnectSpotifyAccountUseCase>(() =>
        _i382.ConnectSpotifyAccountUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i72.LocalDeviceBloc>(() => _i72.LocalDeviceBloc(
          gh<_i240.CacheDevicesUseCase>(),
          gh<_i86.GetCachedDevicesUseCase>(),
          gh<_i775.UpdateCachedDeviceUseCase>(),
        ));
    gh.lazySingleton<_i295.GetStorageTokenUseCase>(
        () => _i295.GetStorageTokenUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i731.StorageTokenUseCase>(
        () => _i731.StorageTokenUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i831.LoginUseCase>(
        () => _i831.LoginUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i491.CheckAuthUseCase>(
        () => _i491.CheckAuthUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i951.GetMeUseCase>(
        () => _i951.GetMeUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i160.FamilyBloc>(() => _i160.FamilyBloc(
          gh<_i311.CreateFamilyUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i677.JoinFamilyUseCase>(),
        ));
    gh.factory<_i1022.DeviceBloc>(
        () => _i1022.DeviceBloc(gh<_i498.FetchDeviceUseCase>()));
    gh.factory<_i411.FamilySettingBloc>(() => _i411.FamilySettingBloc(
          gh<_i779.CreateInviteCodeUseCase>(),
          gh<_i325.DeleteInviteCodeUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i315.ListUserFamilyUseCase>(),
          gh<_i681.GetFamilyDetailUseCase>(),
        ));
    gh.factory<_i918.DeviceGroupBloc>(() => _i918.DeviceGroupBloc(
          gh<_i53.GetDeviceGroupsUseCase>(),
          gh<_i675.CreateDeviceGroupUseCase>(),
          gh<_i326.UpdateDeviceGroupUseCase>(),
          gh<_i350.DeleteDeviceGroupUseCase>(),
          gh<_i69.GetDeviceGroupUseCase>(),
        ));
    gh.factory<_i180.AuthBloc>(() => _i180.AuthBloc(
          gh<_i831.LoginUseCase>(),
          gh<_i491.CheckAuthUseCase>(),
          gh<_i731.StorageTokenUseCase>(),
          gh<_i1009.RegisterUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i943.LogoutUseCase>(),
        ));
    gh.factory<_i111.LoadingRemoteBloc>(() => _i111.LoadingRemoteBloc(
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i297.GetUserUseCase>(),
          gh<_i163.CacheUserUseCase>(),
          gh<_i74.GetSpotifyConnectUseCase>(),
          gh<_i681.GetFamilyDetailUseCase>(),
          gh<_i611.CacheSettingUseCase>(),
        ));
    gh.factory<_i941.SettingBloc>(() => _i941.SettingBloc(
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i1015.CreateSpotifyConnectionUseCase>(),
          gh<_i823.GetCachedUserUseCase>(),
          gh<_i908.GetCachedSettingUseCase>(),
        ));
    gh.factory<_i65.ChatBloc>(() => _i65.ChatBloc(
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i1005.GetAllChatsUseCase>(),
          gh<_i167.GetChatMessagesUseCase>(),
          gh<_i724.AddMessageUseCase>(),
          gh<_i172.SubscribeToMessagesUseCase>(),
          gh<_i157.CreateNewChatUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
