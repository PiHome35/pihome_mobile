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
import '../../features/authentication/domain/usecases/register_device.dart'
    as _i249;
import '../../features/authentication/domain/usecases/storage_token.dart'
    as _i731;
import '../../features/authentication/presentation/bloc/auth_bloc.dart'
    as _i180;
import '../../features/authentication/presentation/bloc/auth_device/auth_device_bloc.dart'
    as _i1003;
import '../../features/chat/data/datasources/chat_remote_datasource.dart'
    as _i159;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/chat/domain/usecases/add_message_usecase.dart' as _i724;
import '../../features/chat/domain/usecases/create_new_chat.dart' as _i157;
import '../../features/chat/domain/usecases/delete_chat_usecase.dart' as _i24;
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
import '../../features/device/data/datasources/ble_setup_datasource.dart'
    as _i402;
import '../../features/device/data/datasources/device_group_remote_datasource.dart'
    as _i898;
import '../../features/device/data/datasources/device_group_status_remote_datasource.dart'
    as _i38;
import '../../features/device/data/datasources/device_local_datasource.dart'
    as _i563;
import '../../features/device/data/datasources/device_remote_datasource.dart'
    as _i590;
import '../../features/device/data/datasources/device_status_remote_datasource.dart'
    as _i230;
import '../../features/device/data/repositories/ble_detail_repository_impl.dart'
    as _i528;
import '../../features/device/data/repositories/ble_scan_repository_impl.dart'
    as _i106;
import '../../features/device/data/repositories/ble_setup_repository_impl.dart'
    as _i565;
import '../../features/device/data/repositories/bluetooth_repository_impl.dart'
    as _i993;
import '../../features/device/data/repositories/device_group_repository_impl.dart'
    as _i454;
import '../../features/device/data/repositories/device_group_status_repository_impl.dart'
    as _i656;
import '../../features/device/data/repositories/device_repository_impl.dart'
    as _i740;
import '../../features/device/data/repositories/device_status_repository_impl.dart'
    as _i236;
import '../../features/device/domain/repositories/ble_detail_repository.dart'
    as _i476;
import '../../features/device/domain/repositories/ble_scan_repository.dart'
    as _i99;
import '../../features/device/domain/repositories/ble_setup_repository.dart'
    as _i776;
import '../../features/device/domain/repositories/bluetooth_repository.dart'
    as _i644;
import '../../features/device/domain/repositories/device_repository.dart'
    as _i985;
import '../../features/device/domain/repositories/i_device_group_repository.dart'
    as _i932;
import '../../features/device/domain/repositories/i_device_group_status_repository.dart'
    as _i109;
import '../../features/device/domain/repositories/i_device_status_repository.dart'
    as _i433;
import '../../features/device/domain/usecases/ble_setup_usecases.dart' as _i936;
import '../../features/device/domain/usecases/create_device_group.dart'
    as _i675;
import '../../features/device/domain/usecases/delete_device_group.dart'
    as _i350;
import '../../features/device/domain/usecases/device/local/cache_devices.dart'
    as _i1065;
import '../../features/device/domain/usecases/device/local/delete_cached_devices.dart'
    as _i927;
import '../../features/device/domain/usecases/device/local/get_cached_devices.dart'
    as _i273;
import '../../features/device/domain/usecases/device/local/update_cached_device.dart'
    as _i577;
import '../../features/device/domain/usecases/device/local/update_cached_devices.dart'
    as _i720;
import '../../features/device/domain/usecases/device/remote/delete_device.dart'
    as _i30;
import '../../features/device/domain/usecases/device/remote/get_device.dart'
    as _i191;
import '../../features/device/domain/usecases/device_group/add_device_group.dart'
    as _i18;
import '../../features/device/domain/usecases/device_group/get_device_group.dart'
    as _i848;
import '../../features/device/domain/usecases/device_group/get_device_groups.dart'
    as _i162;
import '../../features/device/domain/usecases/device_group/get_device_in_group.dart'
    as _i637;
import '../../features/device/domain/usecases/device_heartbeat_usecase.dart'
    as _i910;
import '../../features/device/domain/usecases/group_status/get_device_group_status_usecase.dart'
    as _i74;
import '../../features/device/domain/usecases/group_status/set_device_group_muted_usecase.dart'
    as _i230;
import '../../features/device/domain/usecases/group_status/subscribe_to_device_group_status_usecase.dart'
    as _i559;
import '../../features/device/domain/usecases/status/get_device_status_usecase.dart'
    as _i922;
import '../../features/device/domain/usecases/status/set_device_muted_usecase.dart'
    as _i304;
import '../../features/device/domain/usecases/status/set_device_volume_usecase.dart'
    as _i781;
import '../../features/device/domain/usecases/status/subscribe_to_device_status_usecase.dart'
    as _i476;
import '../../features/device/domain/usecases/update_device_group.dart'
    as _i326;
import '../../features/device/presentation/bloc/device_bloc.dart' as _i1022;
import '../../features/device/presentation/bloc/group/device_group_status_bloc.dart'
    as _i1031;
import '../../features/device/presentation/bloc/local/ble/ble_scan_bloc.dart'
    as _i786;
import '../../features/device/presentation/bloc/local/ble_detail/ble_detail_bloc.dart'
    as _i278;
import '../../features/device/presentation/bloc/local/ble_setup/ble_setup_bloc.dart'
    as _i1054;
import '../../features/device/presentation/bloc/local/bluetooth/bluetooth_bloc.dart'
    as _i891;
import '../../features/device/presentation/bloc/local/device_local_bloc.dart'
    as _i72;
import '../../features/device/presentation/bloc/remote/group/device_group_bloc.dart'
    as _i255;
import '../../features/device/presentation/bloc/status/device_status_bloc.dart'
    as _i932;
import '../../features/family/data/datasources/chat_ai_model_remote_datasource.dart'
    as _i80;
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
import '../../features/setting/domain/usecases/get_chat_ai_models.dart'
    as _i531;
import '../../features/setting/domain/usecases/logout_spotify_connect.dart'
    as _i643;
import '../../features/setting/domain/usecases/update_setting.dart' as _i98;
import '../../features/setting/presentation/bloc/setting_bloc.dart' as _i941;
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
    gh.factory<_i876.LandingBloc>(() => _i876.LandingBloc());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i814.SecureStorageService>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i545.SpotifyAuthService>(
        () => registerModule.spotifyAuthService);
    gh.lazySingleton<_i720.HiveManager>(() => registerModule.hiveManager);
    gh.lazySingleton<_i38.IDeviceGroupStatusRemoteDataSource>(
        () => registerModule.deviceGroupStatusRemoteDataSource);
    gh.lazySingleton<_i590.DeviceRemoteDatasource>(
        () => _i590.DeviceRemoteDatasourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i402.BleSetupDataSource>(
        () => _i402.BleSetupDataSourceImpl());
    gh.lazySingleton<_i115.UserRemoteDataSource>(
        () => _i115.UserRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i230.IDeviceStatusRemoteDataSource>(
        () => registerModule.deviceStatusRemoteDataSource);
    gh.lazySingleton<_i159.IChatRemoteDataSource>(
        () => registerModule.chatRemoteDataSource);
    gh.lazySingleton<_i539.AuthRemoteDataSource>(
        () => _i539.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i746.TokenLocalDataSource>(
        () => _i746.TokenLocalDataSource(gh<_i814.SecureStorageService>()));
    gh.lazySingleton<_i682.FamilyRemoteDataSource>(
        () => _i682.FamilyRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i109.IDeviceGroupStatusRepository>(() =>
        _i656.DeviceGroupStatusRepositoryImpl(
            gh<_i38.IDeviceGroupStatusRemoteDataSource>()));
    gh.lazySingleton<_i80.ChatAiModelRemoteDataSource>(
        () => _i80.ChatAiModelRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i898.DeviceGroupRemoteDatasource>(
        () => _i898.DeviceGroupRemoteDatasourceImpl(gh<_i361.Dio>()));
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
    gh.lazySingleton<_i314.UserLocalDataSource>(
        () => _i314.UserLocalDataSourceImpl(gh<_i720.HiveManager>()));
    gh.lazySingleton<_i389.UserRepository>(() => _i7.UserRepositoryImpl(
          gh<_i115.UserRemoteDataSource>(),
          gh<_i314.UserLocalDataSource>(),
        ));
    gh.factory<_i720.UpdateCachedDevicesUseCase>(() =>
        _i720.UpdateCachedDevicesUseCase(gh<_i563.DeviceLocalDataSource>()));
    gh.lazySingleton<_i932.IDeviceGroupRepository>(() =>
        _i454.DeviceGroupRepositoryImpl(
            gh<_i898.DeviceGroupRemoteDatasource>()));
    gh.factory<_i420.IChatRepository>(
        () => _i504.ChatRepositoryImpl(gh<_i159.IChatRemoteDataSource>()));
    gh.lazySingleton<_i797.FamilyRepository>(
        () => _i590.FamilyRepositoryImpl(gh<_i682.FamilyRemoteDataSource>()));
    gh.lazySingleton<_i99.BleScanRepository>(
        () => _i106.BleScanRepositoryImpl(gh<_i102.BleLocalDataSource>()));
    gh.factory<_i278.BleDetailBloc>(
        () => _i278.BleDetailBloc(gh<_i476.BleDetailRepository>()));
    gh.lazySingleton<_i433.IDeviceStatusRepository>(() =>
        _i236.DeviceStatusRepositoryImpl(
            gh<_i230.IDeviceStatusRemoteDataSource>()));
    gh.lazySingleton<_i508.SettingLocalDataSource>(
        () => _i508.SettingLocalDataSourceImpl(gh<_i720.HiveManager>()));
    gh.lazySingleton<_i776.BleSetupRepository>(
        () => _i565.BleSetupRepositoryImpl(gh<_i402.BleSetupDataSource>()));
    gh.factory<_i637.GetDeviceInGroupUseCase>(() =>
        _i637.GetDeviceInGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i18.AddDeviceGroupUseCase>(
        () => _i18.AddDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i891.BluetoothBloc>(
        () => _i891.BluetoothBloc(gh<_i644.BluetoothRepository>()));
    gh.factory<_i167.GetChatMessagesUseCase>(
        () => _i167.GetChatMessagesUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i1005.GetAllChatsUseCase>(
        () => _i1005.GetAllChatsUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i724.AddMessageUseCase>(
        () => _i724.AddMessageUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i24.DeleteChatUseCase>(
        () => _i24.DeleteChatUseCase(gh<_i420.IChatRepository>()));
    gh.lazySingleton<_i823.GetCachedUserUseCase>(
        () => _i823.GetCachedUserUseCase(gh<_i314.UserLocalDataSource>()));
    gh.factory<_i1017.AuthRepository>(() => _i988.AuthRepositoryImpl(
          gh<_i539.AuthRemoteDataSource>(),
          gh<_i746.TokenLocalDataSource>(),
        ));
    gh.factory<_i559.SubscribeToDeviceGroupStatusUseCase>(() =>
        _i559.SubscribeToDeviceGroupStatusUseCase(
            gh<_i109.IDeviceGroupStatusRepository>()));
    gh.factory<_i74.GetDeviceGroupStatusUseCase>(() =>
        _i74.GetDeviceGroupStatusUseCase(
            gh<_i109.IDeviceGroupStatusRepository>()));
    gh.factory<_i230.SetDeviceGroupMutedUseCase>(() =>
        _i230.SetDeviceGroupMutedUseCase(
            gh<_i109.IDeviceGroupStatusRepository>()));
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
    gh.factory<_i98.UpdateSettingUseCase>(
        () => _i98.UpdateSettingUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i786.BleScanBloc>(
        () => _i786.BleScanBloc(gh<_i99.BleScanRepository>()));
    gh.lazySingleton<_i985.DeviceRepository>(() => _i740.DeviceRepositoryImpl(
          gh<_i590.DeviceRemoteDatasource>(),
          gh<_i563.DeviceLocalDataSource>(),
        ));
    gh.factory<_i613.UserLocalBloc>(
        () => _i613.UserLocalBloc(gh<_i823.GetCachedUserUseCase>()));
    gh.factory<_i1065.CacheDevicesUseCase>(
        () => _i1065.CacheDevicesUseCase(gh<_i985.DeviceRepository>()));
    gh.factory<_i927.DeleteCachedDevices>(
        () => _i927.DeleteCachedDevices(gh<_i985.DeviceRepository>()));
    gh.factory<_i273.GetCachedDevicesUseCase>(
        () => _i273.GetCachedDevicesUseCase(gh<_i985.DeviceRepository>()));
    gh.factory<_i191.GetDevicesUseCase>(
        () => _i191.GetDevicesUseCase(gh<_i985.DeviceRepository>()));
    gh.factory<_i30.DeleteDevice>(
        () => _i30.DeleteDevice(gh<_i985.DeviceRepository>()));
    gh.lazySingleton<_i577.UpdateCachedDeviceUseCase>(
        () => _i577.UpdateCachedDeviceUseCase(gh<_i985.DeviceRepository>()));
    gh.factory<_i157.CreateNewChatUseCase>(
        () => _i157.CreateNewChatUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i976.GetAllChatsUseCase>(
        () => _i976.GetAllChatsUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i172.SubscribeToMessagesUseCase>(
        () => _i172.SubscribeToMessagesUseCase(gh<_i420.IChatRepository>()));
    gh.factory<_i325.DeleteInviteCodeUseCase>(
        () => _i325.DeleteInviteCodeUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i781.SetDeviceVolumeUseCase>(() =>
        _i781.SetDeviceVolumeUseCase(gh<_i433.IDeviceStatusRepository>()));
    gh.factory<_i476.SubscribeToDeviceStatusUseCase>(() =>
        _i476.SubscribeToDeviceStatusUseCase(
            gh<_i433.IDeviceStatusRepository>()));
    gh.factory<_i304.SetDeviceMutedUseCase>(
        () => _i304.SetDeviceMutedUseCase(gh<_i433.IDeviceStatusRepository>()));
    gh.factory<_i922.GetDeviceStatusUseCase>(() =>
        _i922.GetDeviceStatusUseCase(gh<_i433.IDeviceStatusRepository>()));
    gh.factory<_i910.DeviceHeartbeatUseCase>(() =>
        _i910.DeviceHeartbeatUseCase(gh<_i433.IDeviceStatusRepository>()));
    gh.factory<_i350.DeleteDeviceGroupUseCase>(() =>
        _i350.DeleteDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i326.UpdateDeviceGroupUseCase>(() =>
        _i326.UpdateDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i848.GetDeviceGroupUseCase>(
        () => _i848.GetDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i162.GetDeviceGroupsUseCase>(
        () => _i162.GetDeviceGroupsUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i675.CreateDeviceGroupUseCase>(() =>
        _i675.CreateDeviceGroupUseCase(gh<_i932.IDeviceGroupRepository>()));
    gh.factory<_i311.CreateFamilyUseCase>(
        () => _i311.CreateFamilyUseCase(gh<_i797.FamilyRepository>()));
    gh.factory<_i1009.RegisterUseCase>(
        () => _i1009.RegisterUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i936.ReadClientIdUseCase>(
        () => _i936.ReadClientIdUseCase(gh<_i776.BleSetupRepository>()));
    gh.factory<_i936.ReadMacAddressUseCase>(
        () => _i936.ReadMacAddressUseCase(gh<_i776.BleSetupRepository>()));
    gh.factory<_i936.WriteClientSecretUseCase>(
        () => _i936.WriteClientSecretUseCase(gh<_i776.BleSetupRepository>()));
    gh.factory<_i936.WriteWifiSsidUseCase>(
        () => _i936.WriteWifiSsidUseCase(gh<_i776.BleSetupRepository>()));
    gh.factory<_i936.WriteWifiPasswordUseCase>(
        () => _i936.WriteWifiPasswordUseCase(gh<_i776.BleSetupRepository>()));
    gh.factory<_i936.TriggerWifiConnectUseCase>(
        () => _i936.TriggerWifiConnectUseCase(gh<_i776.BleSetupRepository>()));
    gh.factory<_i936.CheckSetupCompletedUseCase>(
        () => _i936.CheckSetupCompletedUseCase(gh<_i776.BleSetupRepository>()));
    gh.lazySingleton<_i249.RegisterDeviceUseCase>(
        () => _i249.RegisterDeviceUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i731.StorageTokenUseCase>(
        () => _i731.StorageTokenUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i831.LoginUseCase>(
        () => _i831.LoginUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i491.CheckAuthUseCase>(
        () => _i491.CheckAuthUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i951.GetMeUseCase>(
        () => _i951.GetMeUseCase(gh<_i1017.AuthRepository>()));
    gh.factory<_i295.GetStorageTokenUseCase>(
        () => _i295.GetStorageTokenUseCase(gh<_i1017.AuthRepository>()));
    gh.lazySingleton<_i819.SettingRepository>(() => _i182.SettingRepositoryImpl(
          gh<_i545.SpotifyAuthService>(),
          gh<_i429.SettingRemoteDataSource>(),
          gh<_i508.SettingLocalDataSource>(),
          gh<_i80.ChatAiModelRemoteDataSource>(),
        ));
    gh.factory<_i72.LocalDeviceBloc>(() => _i72.LocalDeviceBloc(
          gh<_i1065.CacheDevicesUseCase>(),
          gh<_i273.GetCachedDevicesUseCase>(),
          gh<_i577.UpdateCachedDeviceUseCase>(),
          gh<_i720.UpdateCachedDevicesUseCase>(),
        ));
    gh.factory<_i1054.BleSetupBloc>(() => _i1054.BleSetupBloc(
          readClientId: gh<_i936.ReadClientIdUseCase>(),
          readMacAddress: gh<_i936.ReadMacAddressUseCase>(),
          writeClientSecret: gh<_i936.WriteClientSecretUseCase>(),
          writeWifiSsid: gh<_i936.WriteWifiSsidUseCase>(),
          writeWifiPassword: gh<_i936.WriteWifiPasswordUseCase>(),
          triggerWifiConnect: gh<_i936.TriggerWifiConnectUseCase>(),
          checkSetupCompleted: gh<_i936.CheckSetupCompletedUseCase>(),
          registerDevice: gh<_i249.RegisterDeviceUseCase>(),
          getStorageToken: gh<_i295.GetStorageTokenUseCase>(),
        ));
    gh.factory<_i160.FamilyBloc>(() => _i160.FamilyBloc(
          gh<_i311.CreateFamilyUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i677.JoinFamilyUseCase>(),
        ));
    gh.factory<_i411.FamilySettingBloc>(() => _i411.FamilySettingBloc(
          gh<_i779.CreateInviteCodeUseCase>(),
          gh<_i325.DeleteInviteCodeUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i315.ListUserFamilyUseCase>(),
          gh<_i681.GetFamilyDetailUseCase>(),
        ));
    gh.factory<_i180.AuthBloc>(() => _i180.AuthBloc(
          gh<_i831.LoginUseCase>(),
          gh<_i491.CheckAuthUseCase>(),
          gh<_i731.StorageTokenUseCase>(),
          gh<_i1009.RegisterUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i943.LogoutUseCase>(),
        ));
    gh.factory<_i255.DeviceGroupBloc>(() => _i255.DeviceGroupBloc(
          gh<_i162.GetDeviceGroupsUseCase>(),
          gh<_i675.CreateDeviceGroupUseCase>(),
          gh<_i326.UpdateDeviceGroupUseCase>(),
          gh<_i350.DeleteDeviceGroupUseCase>(),
          gh<_i848.GetDeviceGroupUseCase>(),
          gh<_i637.GetDeviceInGroupUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i18.AddDeviceGroupUseCase>(),
        ));
    gh.factory<_i1003.AuthDeviceBloc>(
        () => _i1003.AuthDeviceBloc(gh<_i249.RegisterDeviceUseCase>()));
    gh.factory<_i1022.DeviceBloc>(() => _i1022.DeviceBloc(
          gh<_i191.GetDevicesUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i1065.CacheDevicesUseCase>(),
          gh<_i162.GetDeviceGroupsUseCase>(),
        ));
    gh.factory<_i932.DeviceStatusBloc>(() => _i932.DeviceStatusBloc(
          gh<_i304.SetDeviceMutedUseCase>(),
          gh<_i781.SetDeviceVolumeUseCase>(),
          gh<_i476.SubscribeToDeviceStatusUseCase>(),
          gh<_i922.GetDeviceStatusUseCase>(),
          gh<_i910.DeviceHeartbeatUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
        ));
    gh.factory<_i1015.CreateSpotifyConnectionUseCase>(() =>
        _i1015.CreateSpotifyConnectionUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i643.LogoutSpotifyConnectUseCase>(
        () => _i643.LogoutSpotifyConnectUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i1031.DeviceGroupStatusBloc>(() => _i1031.DeviceGroupStatusBloc(
          gh<_i74.GetDeviceGroupStatusUseCase>(),
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i230.SetDeviceGroupMutedUseCase>(),
          gh<_i559.SubscribeToDeviceGroupStatusUseCase>(),
        ));
    gh.factory<_i65.ChatBloc>(() => _i65.ChatBloc(
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i1005.GetAllChatsUseCase>(),
          gh<_i167.GetChatMessagesUseCase>(),
          gh<_i724.AddMessageUseCase>(),
          gh<_i172.SubscribeToMessagesUseCase>(),
          gh<_i157.CreateNewChatUseCase>(),
          gh<_i24.DeleteChatUseCase>(),
        ));
    gh.factory<_i611.CacheSettingUseCase>(
        () => _i611.CacheSettingUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i74.GetSpotifyConnectUseCase>(
        () => _i74.GetSpotifyConnectUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i908.GetCachedSettingUseCase>(
        () => _i908.GetCachedSettingUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i382.ConnectSpotifyAccountUseCase>(() =>
        _i382.ConnectSpotifyAccountUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i531.GetChatAiModelsUseCase>(
        () => _i531.GetChatAiModelsUseCase(gh<_i819.SettingRepository>()));
    gh.factory<_i941.SettingBloc>(() => _i941.SettingBloc(
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i1015.CreateSpotifyConnectionUseCase>(),
          gh<_i823.GetCachedUserUseCase>(),
          gh<_i908.GetCachedSettingUseCase>(),
          gh<_i531.GetChatAiModelsUseCase>(),
          gh<_i98.UpdateSettingUseCase>(),
          gh<_i611.CacheSettingUseCase>(),
        ));
    gh.factory<_i111.LoadingRemoteBloc>(() => _i111.LoadingRemoteBloc(
          gh<_i295.GetStorageTokenUseCase>(),
          gh<_i297.GetUserUseCase>(),
          gh<_i163.CacheUserUseCase>(),
          gh<_i74.GetSpotifyConnectUseCase>(),
          gh<_i681.GetFamilyDetailUseCase>(),
          gh<_i611.CacheSettingUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
