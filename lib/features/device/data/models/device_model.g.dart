// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceModelAdapter extends TypeAdapter<DeviceModel> {
  @override
  final int typeId = 0;

  @override
  DeviceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceModel(
      id: fields[0] as String,
      clientId: fields[1] as String,
      macAddress: fields[2] as String,
      name: fields[3] as String,
      familyId: fields[4] as String,
      deviceGroupId: fields[5] as String?,
      isOn: fields[6] as bool,
      isMuted: fields[7] as bool,
      volumePercent: fields[8] as int,
      isSoundServer: fields[9] as bool,
      createdAt: fields[10] as String,
      updatedAt: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clientId)
      ..writeByte(2)
      ..write(obj.macAddress)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.familyId)
      ..writeByte(5)
      ..write(obj.deviceGroupId)
      ..writeByte(6)
      ..write(obj.isOn)
      ..writeByte(7)
      ..write(obj.isMuted)
      ..writeByte(8)
      ..write(obj.volumePercent)
      ..writeByte(9)
      ..write(obj.isSoundServer)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
