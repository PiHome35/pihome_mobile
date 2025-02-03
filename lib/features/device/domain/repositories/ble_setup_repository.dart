abstract class BleSetupRepository {
  Future<String> readClientId();
  Future<String> readMacAddress();
  Future<void> writeClientSecret(String secret);
  Future<void> writeWifiSsid(String ssid);
  Future<void> writeWifiPassword(String password);
  Future<void> triggerWifiConnect();
  Future<bool> checkSetupCompleted();
}
