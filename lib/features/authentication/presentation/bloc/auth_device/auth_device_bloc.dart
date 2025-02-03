import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/register_device.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_device/auth_device_event.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_device/auth_device_state.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';

@injectable
class AuthDeviceBloc extends Bloc<AuthDeviceEvent, AuthDeviceState> {
  final RegisterDeviceUseCase _registerDeviceUseCase;

  AuthDeviceBloc(this._registerDeviceUseCase)
      : super(const AuthDeviceInitial()) {
    on<RegisterDeviceEvent>(_onRegisterDevice);
  }

  Future<void> _onRegisterDevice(
    RegisterDeviceEvent event,
    Emitter<AuthDeviceState> emit,
  ) async {
    emit(const AuthDeviceLoading());

    final dataState = await _registerDeviceUseCase.execute(
      RegisterDeviceParams(
        accessToken: event.accessToken,
        clientId: event.clientId,
        macAddress: event.macAddress,
        name: event.name,
      ),
    );

    if (dataState is DataSuccess) {
      final device = dataState.data!.device;
      final clientSecret = dataState.data!.clientSecret;
      emit(AuthDeviceSuccess(device, clientSecret));
    }

    if (dataState is DataFailed) {
      emit(AuthDeviceError(dataState.exception!));
    }
  }
}
