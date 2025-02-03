import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_state.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_state.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/form/device_group_form_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/form/device_group_form_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/form/device_group_form_state.dart';

class DeviceGroupCreationPage extends StatelessWidget {
  final String familyId;
  final DeviceGroupEntity? initialGroup;

  const DeviceGroupCreationPage({
    super.key,
    required this.familyId,
    this.initialGroup,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<DeviceBloc>()..add(const GetDevices()),
        ),
        BlocProvider(
          create: (context) => getIt<DeviceGroupBloc>(),
        ),
        BlocProvider(
          create: (context) => DeviceGroupFormBloc(
            initialName: initialGroup?.name,
            initialDevices: initialGroup?.devices.toSet(),
          ),
        ),
      ],
      child: DeviceGroupCreationView(
        familyId: familyId,
        initialGroup: initialGroup,
      ),
    );
  }
}

class DeviceGroupCreationView extends StatefulWidget {
  final String familyId;
  final DeviceGroupEntity? initialGroup;

  const DeviceGroupCreationView({
    super.key,
    required this.familyId,
    this.initialGroup,
  });

  @override
  State<DeviceGroupCreationView> createState() =>
      _DeviceGroupCreationViewState();
}

class _DeviceGroupCreationViewState extends State<DeviceGroupCreationView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool get isUpdateMode => widget.initialGroup != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialGroup?.name);
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    context
        .read<DeviceGroupFormBloc>()
        .add(UpdateNameEvent(_nameController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final formState = context.read<DeviceGroupFormBloc>().state;
    if (!formState.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one device'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final group = isUpdateMode
        ? DeviceGroupEntity(
            id: widget.initialGroup!.id,
            name: formState.name.trim(),
            familyId: widget.familyId,
            createdAt: widget.initialGroup!.createdAt,
            updatedAt: now.toIso8601String(),
            devices: formState.selectedDevices.toList(),
          )
        : DeviceGroupEntity(
            id: now.millisecondsSinceEpoch.toString(),
            name: formState.name.trim(),
            familyId: widget.familyId,
            createdAt: now.toIso8601String(),
            updatedAt: now.toIso8601String(),
            devices: formState.selectedDevices.toList(),
          );

    if (isUpdateMode) {
      context.read<DeviceGroupBloc>().add(UpdateDeviceGroupEvent(group));
    } else {
      context.read<DeviceGroupBloc>().add(
            CreateDeviceGroupEvent(
              formState.name.trim(),
              formState.selectedDevices.map((d) => d.id).toList(),
            ),
          );
    }
    context.pop(true);
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
          isUpdateMode ? 'Edit Device Group' : 'Create Device Group',
          style: AppTextStyles.headingMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<DeviceGroupBloc, DeviceGroupState>(
        listener: (context, state) async {
          log('state device group creation: $state');
          if (state is DeviceGroupError) {
            await MinimalDialog.show(
              context: context,
              title: 'Error',
              message: state.message,
              primaryButtonText: 'OK',
              type: DialogType.error,
            );
            if (context.mounted) {
              context.pop(false);
            }
          } else if (state is DeviceGroupsLoaded) {
            log('state is Loaded: $state');
            final message = isUpdateMode
                ? 'Device group updated successfully!'
                : 'Device group created successfully!';

            await MinimalDialog.show(
              context: context,
              title: 'Success',
              message: message,
              primaryButtonText: 'OK',
              type: DialogType.success,
              showCloseButton: false,
            );

            if (context.mounted) {
              context.pop(true);
            }
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group Name',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      style: AppTextStyles.input.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter group name',
                        hintStyle: AppTextStyles.inputHint,
                        prefixIcon: Icon(
                          Icons.group_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a group name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.devices_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Select Devices',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${context.read<DeviceGroupFormBloc>().state.selectedDevices.length} selected',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<DeviceBloc, DeviceState>(
                  builder: (context, state) {
                    return switch (state) {
                      DeviceInitial() => const SizedBox.shrink(),
                      DeviceLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      DeviceLoaded() => _buildDeviceList(state.devices),
                      DeviceError() => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 48,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: AppTextStyles.error,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              isUpdateMode ? 'Update Group' : 'Create Group',
              style: AppTextStyles.buttonLarge,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceList(List<DeviceEntity> devices) {
    final theme = Theme.of(context);

    final availableDevices = devices.where((device) {
      if (isUpdateMode && widget.initialGroup!.devices.contains(device)) {
        return true;
      }
      return device.deviceGroupId == null;
    }).toList();

    if (availableDevices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No devices available',
              style: AppTextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All devices are already in groups',
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: availableDevices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final device = availableDevices[index];
        return BlocBuilder<DeviceGroupFormBloc, DeviceGroupFormState>(
          builder: (context, state) {
            final isSelected = state.selectedDevices.contains(device);
            final wasInitiallySelected =
                widget.initialGroup?.devices.contains(device) ?? false;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  context
                      .read<DeviceGroupFormBloc>()
                      .add(ToggleDeviceEvent(device));
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.speaker_group_rounded,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.name,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              device.macAddress,
                              style: AppTextStyles.deviceType.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            if (isUpdateMode && wasInitiallySelected) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Current Member',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          context
                              .read<DeviceGroupFormBloc>()
                              .add(ToggleDeviceEvent(device));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
