import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/form/device_group_form_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/form/device_group_form_state.dart';

class DeviceGroupFormBloc
    extends Bloc<DeviceGroupFormEvent, DeviceGroupFormState> {
  DeviceGroupFormBloc({
    String? initialName,
    Set<DeviceEntity>? initialDevices,
  }) : super(DeviceGroupFormState(
          name: initialName ?? '',
          selectedDevices: initialDevices ?? {},
          isValid: initialName?.isNotEmpty == true &&
              (initialDevices?.isNotEmpty == true),
        )) {
    on<UpdateNameEvent>(_onUpdateName);
    on<ToggleDeviceEvent>(_onToggleDevice);
    on<ValidateFormEvent>(_onValidateForm);
  }

  void _onUpdateName(
      UpdateNameEvent event, Emitter<DeviceGroupFormState> emit) {
    final newState = state.copyWith(
      name: event.name,
      isValid: event.name.trim().isNotEmpty && state.selectedDevices.isNotEmpty,
    );
    emit(newState);
  }

  void _onToggleDevice(
      ToggleDeviceEvent event, Emitter<DeviceGroupFormState> emit) {
    final updatedDevices = Set<DeviceEntity>.from(state.selectedDevices);
    if (updatedDevices.contains(event.device)) {
      updatedDevices.remove(event.device);
    } else {
      updatedDevices.add(event.device);
    }

    emit(state.copyWith(
      selectedDevices: updatedDevices,
      isValid: state.name.trim().isNotEmpty && updatedDevices.isNotEmpty,
    ));
  }

  void _onValidateForm(
      ValidateFormEvent event, Emitter<DeviceGroupFormState> emit) {
    final isValid =
        state.name.trim().isNotEmpty && state.selectedDevices.isNotEmpty;
    emit(state.copyWith(isValid: isValid));
  }
}
