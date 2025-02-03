import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_setup/ble_setup_state.dart';

class BleSetupEntity extends Equatable {
  final String? clientId;
  final String? macAddress;
  final String deviceName;
  final String? wifiSsid;
  final String? wifiPassword;
  final bool isSetupCompleted;
  final BleSetupState? lastSuccessState;

  const BleSetupEntity({
    this.clientId,
    this.macAddress,
    required this.deviceName,
    this.wifiSsid,
    this.wifiPassword,
    this.isSetupCompleted = false,
    this.lastSuccessState,
  });

  @override
  List<Object?> get props => [
        clientId,
        macAddress,
        deviceName,
        wifiSsid,
        wifiPassword,
        isSetupCompleted,
        lastSuccessState,
      ];

  BleSetupEntity copyWith({
    String? clientId,
    String? macAddress,
    String? deviceName,
    String? wifiSsid,
    String? wifiPassword,
    bool? isSetupCompleted,
    BleSetupState? lastSuccessState,
  }) {
    return BleSetupEntity(
      clientId: clientId ?? this.clientId,
      macAddress: macAddress ?? this.macAddress,
      deviceName: deviceName ?? this.deviceName,
      wifiSsid: wifiSsid ?? this.wifiSsid,
      wifiPassword: wifiPassword ?? this.wifiPassword,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
      lastSuccessState: lastSuccessState ?? this.lastSuccessState,
    );
  }
}

class BleServiceConfig {
  static const String targetServiceUuid =
      "ee01c6b7-69b1-4551-ba97-578f7993ba35";
  static const String clientIdCharUuid = "7623a3e1-608e-416c-b72f-ff6ef3bb2b99";
  static const String clientSecretCharUuid =
      "3207cc58-544c-486b-ab42-3f81741f8b35";
  static const String wifiSsidCharUuid = "a865cf29-0fb1-4714-ab49-a0904199ad1c";
  static const String wifiPasswordCharUuid =
      "f08249f9-3141-4d2a-8d48-5ff734361b96";
  static const String wifiMacCharUuid = "3f4548fc-a528-4c93-8e7a-450e7fed7fb9";
  static const String wifiConnectTriggerCharUuid =
      "ae0d0dcf-d261-45cc-b571-1f58f59ca2fd";
  static const String setupCompletedCharUuid =
      "a25067c6-b898-42b7-bcc3-492e0bff0a0e";
}
