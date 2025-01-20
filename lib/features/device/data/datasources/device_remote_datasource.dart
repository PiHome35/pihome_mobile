import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';

abstract class DeviceDatasource {
  Future<List<DeviceModel>> getDevices();
}

@LazySingleton(as: DeviceDatasource)
@Environment('dev')
class DeviceRemoteDatasourceImpl implements DeviceDatasource {
  @override
  Future<List<DeviceModel>> getDevices() async {
    // TODO: Implement actual API call
    return [];
  }
}
