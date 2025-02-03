import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/device/data/datasources/ble_setup_datasource.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_setup/ble_setup_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_setup/ble_setup_state.dart';
import 'package:network_info_plus/network_info_plus.dart';

class DeviceBleSetupPage extends StatelessWidget {
  final BleDeviceEntity device;

  const DeviceBleSetupPage({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    getIt<BleSetupDataSource>().setDevice(device.device);

    return BlocProvider(
      create: (_) => getIt<BleSetupBloc>()
        ..add(StartDeviceSetup(
          deviceName: device.name,
          currentWifiSsid: '',
        )),
      child: DeviceBleSetupView(device: device),
    );
  }
}

class DeviceBleSetupView extends StatefulWidget {
  final BleDeviceEntity device;

  const DeviceBleSetupView({
    super.key,
    required this.device,
  });

  @override
  State<DeviceBleSetupView> createState() => _DeviceBleSetupViewState();
}

class _DeviceBleSetupViewState extends State<DeviceBleSetupView> {
  final _deviceNameController = TextEditingController();
  final _wifiPasswordController = TextEditingController();
  String? _currentWifiSsid;

  @override
  void initState() {
    super.initState();
    _deviceNameController.text = widget.device.name;
    _getCurrentWifiSsid();
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _wifiPasswordController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentWifiSsid() async {
    try {
      final networkInfo = NetworkInfo();
      final ssid = await networkInfo.getWifiName();
      if (ssid != null) {
        setState(() {
          _currentWifiSsid = ssid.replaceAll('"', '');
        });
        context.read<BleSetupBloc>().add(StartDeviceSetup(
              deviceName: widget.device.name,
              currentWifiSsid: _currentWifiSsid!,
            ));
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Setup Device',
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: BlocConsumer<BleSetupBloc, BleSetupState>(
        listener: (context, state) {
          if (state is BleSetupError) {
            MinimalDialog.show(
              context: context,
              title: 'Setup Error',
              message: state.errorMessage ?? 'An unknown error occurred',
              primaryButtonText: 'OK',
              type: DialogType.error,
            );
          } else if (state is BleSetupCompleted) {
            MinimalDialog.show(
              context: context,
              title: 'Setup Complete',
              message:
                  'Your device has been successfully set up and connected to WiFi.',
              primaryButtonText: 'Continue',
              type: DialogType.success,
              onPrimaryPressed: () {
                context.go(AppRoutes.landing);
              },
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProgressIndicator(state),
                const SizedBox(height: 24),
                _buildDeviceNameField(),
                const SizedBox(height: 16),
                _buildWifiInfo(),
                const SizedBox(height: 16),
                _buildWifiPasswordField(),
                const SizedBox(height: 24),
                _buildActionButton(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator(BleSetupState state) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildStepCircle(1, _getStepProgress(state) >= 1),
                  _buildStepLine(_getStepProgress(state) > 1),
                  _buildStepCircle(2, _getStepProgress(state) >= 2),
                  _buildStepLine(_getStepProgress(state) > 2),
                  _buildStepCircle(3, _getStepProgress(state) >= 3),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Device Info',
                      style: AppTextStyles.withColor(
                        AppTextStyles.labelSmall,
                        _getStepProgress(state) >= 1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Registration',
                      style: AppTextStyles.withColor(
                        AppTextStyles.labelSmall,
                        _getStepProgress(state) >= 2
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'WiFi Setup',
                      style: AppTextStyles.withColor(
                        AppTextStyles.labelSmall,
                        _getStepProgress(state) >= 3
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildServiceStatus(state),
      ],
    );
  }

  Widget _buildServiceStatus(BleSetupState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Status',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            'Read Client ID',
            state.setupData?.clientId != null,
            state is BleSetupLoading && _getStepProgress(state) == 1,
            state is BleSetupError && _getStepProgress(state) == 0,
          ),
          _buildStatusItem(
            'Read MAC Address',
            state.setupData?.macAddress != null,
            state is BleSetupLoading && _getStepProgress(state) == 1,
            state is BleSetupError && _getStepProgress(state) == 0,
          ),
          _buildStatusItem(
            'Write WiFi SSID',
            state.setupData?.wifiSsid != null,
            state is BleSetupLoading && _getStepProgress(state) == 1,
            state is BleSetupError && _getStepProgress(state) == 1,
          ),
          _buildStatusItem(
            'Write WiFi Password',
            state.setupData?.wifiPassword != null,
            state is BleSetupLoading && _getStepProgress(state) == 2,
            state is BleSetupError && _getStepProgress(state) == 2,
          ),
          _buildStatusItem(
            'Register Device',
            state is BleSetupSecretWritten || _getStepProgress(state) > 2,
            state is BleSetupLoading && _getStepProgress(state) == 3,
            state is BleSetupError && _getStepProgress(state) == 3,
          ),
          _buildStatusItem(
            'Write Client Secret',
            state is BleSetupSecretWritten || _getStepProgress(state) > 2,
            state is BleSetupLoading && _getStepProgress(state) == 3,
            state is BleSetupError && _getStepProgress(state) == 3,
          ),
          _buildStatusItem(
            'Trigger WiFi Connect',
            state is BleSetupWifiConnecting || state is BleSetupCompleted,
            state is BleSetupLoading && _getStepProgress(state) == 3,
            state is BleSetupError && _getStepProgress(state) == 3,
          ),
          _buildStatusItem(
            'Setup Completed',
            state is BleSetupCompleted,
            state is BleSetupLoading && _getStepProgress(state) == 3,
            state is BleSetupError && _getStepProgress(state) == 3,
          ),
          if (state is BleSetupError)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage ?? 'An error occurred',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodySmall,
                        Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    String label,
    bool isCompleted,
    bool isLoading,
    bool hasError,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasError
                          ? Theme.of(context).colorScheme.errorContainer
                          : isCompleted
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1)
                              : Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.1),
                      border: Border.all(
                        color: hasError
                            ? Theme.of(context).colorScheme.error
                            : isCompleted
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        hasError
                            ? Icons.close_rounded
                            : isCompleted
                                ? Icons.check_rounded
                                : Icons.circle_outlined,
                        size: 16,
                        color: hasError
                            ? Theme.of(context).colorScheme.error
                            : isCompleted
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.withColor(
                AppTextStyles.bodyMedium,
                hasError
                    ? Theme.of(context).colorScheme.error
                    : isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, bool isCompleted) {
    final color = isCompleted
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isCompleted
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: color,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? Icon(
                Icons.check_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              )
            : Text(
                step.toString(),
                style: AppTextStyles.withColor(
                  AppTextStyles.labelMedium,
                  color,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isCompleted
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  int _getStepProgress(BleSetupState state) {
    return switch (state) {
      BleSetupInitial() => 0,
      BleSetupLoading() => 1,
      BleSetupDeviceInfoRead() => 1,
      BleSetupWifiCredentialsWritten() => 2,
      BleSetupSecretWritten() => 3,
      BleSetupWifiConnecting() => 3,
      BleSetupCompleted() => 3,
      BleSetupError() => state.setupData?.lastSuccessState == null
          ? 0
          : _getStepProgress(state.setupData!.lastSuccessState!),
    };
  }

  Widget _buildDeviceNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Name',
          style: AppTextStyles.labelMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _deviceNameController,
          decoration: InputDecoration(
            hintText: 'Enter device name',
            hintStyle: AppTextStyles.inputHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.devices_rounded,
              color: Theme.of(context).colorScheme.outline,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          style: AppTextStyles.input,
        ),
      ],
    );
  }

  Widget _buildWifiInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WiFi Network',
          style: AppTextStyles.labelMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.wifi_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Network',
                      style: AppTextStyles.withColor(
                        AppTextStyles.labelSmall,
                        Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentWifiSsid ?? 'Not connected to WiFi',
                      style: AppTextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWifiPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WiFi Password',
          style: AppTextStyles.labelMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _wifiPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter WiFi password',
            hintStyle: AppTextStyles.inputHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.lock_rounded,
              color: Theme.of(context).colorScheme.outline,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          style: AppTextStyles.input,
        ),
      ],
    );
  }

  Widget _buildActionButton(BleSetupState state) {
    final isLoading = state is BleSetupLoading;
    final isCompleted = state is BleSetupCompleted;
    final hasWifiPassword = _wifiPasswordController.text.isNotEmpty;
    final hasDeviceName = _deviceNameController.text.isNotEmpty;

    String buttonText = 'Connect Device';
    VoidCallback? onPressed;

    if (state is BleSetupDeviceInfoRead && !hasWifiPassword) {
      buttonText = 'Set WiFi Password';
      onPressed = () {
        context.read<BleSetupBloc>().add(
              WriteWifiCredentials(
                password: _wifiPasswordController.text,
              ),
            );
      };
    } else if (state is BleSetupWifiCredentialsWritten && hasDeviceName) {
      buttonText = 'Register & Connect';
      onPressed = () {
        context.read<BleSetupBloc>().add(
              RegisterAndConnectDevice(
                deviceName: _deviceNameController.text,
              ),
            );
      };
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading || isCompleted ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                buttonText,
                style: AppTextStyles.buttonMedium,
              ),
      ),
    );
  }
}
