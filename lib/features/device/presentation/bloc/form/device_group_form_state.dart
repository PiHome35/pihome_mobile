import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

class DeviceGroupFormState extends Equatable {
  final String name;
  final Set<DeviceEntity> selectedDevices;
  final bool isValid;
  final String? error;

  const DeviceGroupFormState({
    this.name = '',
    this.selectedDevices = const {},
    this.isValid = false,
    this.error,
  });

  DeviceGroupFormState copyWith({
    String? name,
    Set<DeviceEntity>? selectedDevices,
    bool? isValid,
    String? error,
  }) {
    return DeviceGroupFormState(
      name: name ?? this.name,
      selectedDevices: selectedDevices ?? this.selectedDevices,
      isValid: isValid ?? this.isValid,
      error: error,
    );
  }

  @override
  List<Object?> get props => [name, selectedDevices, isValid, error];
}
