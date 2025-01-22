import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_pihome/core/data/models/user_model.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';
import 'package:mobile_pihome/features/setting/data/models/setting_model.dart';

class HiveManager {
  // Private constructor
  HiveManager._();

  // Singleton instance
  static final HiveManager _instance = HiveManager._();

  // Factory constructor
  factory HiveManager() => _instance;

  // Private box instances
  late Box<DeviceModel> _deviceBox;
  late Box<UserModel> _userBox;
  late Box<SettingModel> _settingBox;

  // Public getters
  Box<DeviceModel> get deviceBox => _deviceBox;
  Box<UserModel> get userBox => _userBox;
  Box<SettingModel> get settingBox => _settingBox;
  Future<void> initHive() async {
    await Hive.initFlutter();
    await _registerAdapters();
    await _openAllBoxes();
  }

  Future<void> _openAllBoxes() async {
    _deviceBox = await Hive.openBox<DeviceModel>('device');
    _userBox = await Hive.openBox<UserModel>('user');
    _settingBox = await Hive.openBox<SettingModel>('setting');
  }

  Future<void> _registerAdapters() async {
    Hive.registerAdapter(DeviceModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(SettingModelAdapter());
  }

  Future<void> closeHive() async {
    await _deviceBox.close();
    await _userBox.close();
    await _settingBox.close();
    await Hive.close();
  }
}
