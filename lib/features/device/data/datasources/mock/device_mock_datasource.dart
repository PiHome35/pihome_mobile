import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/data/datasources/device_remote_datasource.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';

@Environment('mock')
@LazySingleton(as: DeviceDatasource)
class DeviceMockDatasourceImpl implements DeviceDatasource {
  final List<DeviceModel> mockDevices = [
    const DeviceModel(
      id: 'speaker-001',
      name: 'Living Room Speaker',
      familyId: 'family-001',
      groupId: 'group-001',
      createdAt: '2025-01-10 14:08:07',
      updatedAt: '2025-01-10 14:08:07',
      isOn: true,
      // type: 'speaker',
    ),
    const DeviceModel(
      id: 'speaker-002',
      name: 'Bedroom Speaker',
      familyId: 'family-001',
      groupId: 'group-001',
      createdAt: '2025-01-11 14:08:07',
      updatedAt: '2025-01-11 14:08:07',
      isOn: true,
      // type: 'speaker',
    ),
    const DeviceModel(
      id: 'speaker-003',
      name: 'Kitchen Speaker',
      familyId: 'family-001',
      groupId: 'group-001',
      createdAt: '2025-01-11 16:08:07',
      updatedAt: '2025-01-11 16:08:07',
      isOn: true,
      // type: 'speaker',
    ),
    const DeviceModel(
      id: 'speaker-004',
      name: 'Office Speaker',
      familyId: 'family-001',
      groupId: 'group-001',
      createdAt: '2025-01-9 14:08:07',
      updatedAt: '2025-01-9 14:08:07',
      isOn: true,
      // type: 'speaker',
    ),
    const DeviceModel(
      id: 'speaker-005',
      name: 'Dining Room Speaker',
      familyId: 'family-001',
      groupId: 'group-001',
      createdAt: '2025-01-08 14:08:07',
      updatedAt: '2025-01-08 14:08:07',
      isOn: false,
      // type: 'speaker',
    ),
  ];

  @override
  Future<List<DeviceModel>> getDevices() async {
    await Future.delayed(const Duration(seconds: 3));
    return mockDevices;
  }
}
