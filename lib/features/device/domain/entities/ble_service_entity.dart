import 'package:equatable/equatable.dart';

class BleServiceEntity extends Equatable {
  final String uuid;
  final List<BleCharacteristicEntity> characteristics;

  const BleServiceEntity({
    required this.uuid,
    required this.characteristics,
  });

  @override
  List<Object?> get props => [uuid, characteristics];
}

class BleCharacteristicEntity extends Equatable {
  final String uuid;
  final bool canRead;
  final bool canWrite;
  final bool canNotify;
  final String? value;

  const BleCharacteristicEntity({
    required this.uuid,
    required this.canRead,
    required this.canWrite,
    required this.canNotify,
    this.value,
  });

  @override
  List<Object?> get props => [uuid, canRead, canWrite, canNotify, value];
}
