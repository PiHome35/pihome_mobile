import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_state.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_group_creation_page.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/device_group_card.dart';

class DeviceGroupPage extends StatelessWidget {
  final String familyId;

  const DeviceGroupPage({
    super.key,
    required this.familyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DeviceGroupBloc>()..add(const GetDeviceGroupsEvent()),
      child: DeviceGroupView(familyId: familyId),
    );
  }
}

class DeviceGroupView extends StatelessWidget {
  final String familyId;

  const DeviceGroupView({
    super.key,
    required this.familyId,
  });

  Future<void> _handleDeleteGroup(
      BuildContext context, DeviceGroupEntity group) async {
    final confirmed = await MinimalDialog.show(
      context: context,
      title: 'Delete Group',
      message:
          'Are you sure you want to delete "${group.name}"? This action cannot be undone.',
      primaryButtonText: 'Delete',
      secondaryButtonText: 'Cancel',
      type: DialogType.caution,
    );

    if (confirmed == true && context.mounted) {
      context.read<DeviceGroupBloc>().add(DeleteDeviceGroupEvent(group.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final deviceGroupBloc = context.read<DeviceGroupBloc>();

    return BlocConsumer<DeviceGroupBloc, DeviceGroupState>(
      // bloc: deviceGroupBloc,
      listener: (context, state) async {
        log('state is: $state');
        if (state is DeviceGroupError) {
          await MinimalDialog.show(
            context: context,
            title: 'Error',
            message: state.message,
            primaryButtonText: 'OK',
            type: DialogType.error,
          );
        } else if (state is DeviceGroupDeleted) {
          await MinimalDialog.show(
            context: context,
            title: 'Success',
            message: 'Device group deleted successfully!',
            primaryButtonText: 'OK',
            type: DialogType.success,
            showCloseButton: false,
          );

          if (context.mounted) {
            // deviceGroupBloc.add(const GetDeviceGroupsEvent());
            context.read<DeviceGroupBloc>().add(const GetDeviceGroupsEvent());
          }
        }
      },
      builder: (context, state) {
        final deviceGroupBloc = context.read<DeviceGroupBloc>();
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Device Groups',
              style: AppTextStyles.headingMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  onPressed: () async {
                    final result =
                        await AppRoutes.navigateToDeviceGroupCreation(
                      context,
                      familyId,
                    );
                    log('result is created: $result');

                    if (result == true) {
                      log('result is true => get device groups');
                      if (context.mounted) {
                        deviceGroupBloc.add(const GetDeviceGroupsEvent());
                        log('device group bloc is added');
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state is DeviceGroupInitial) {
                return const SizedBox.shrink();
              }

              if (state is DeviceGroupLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }

              if (state is DeviceGroupsLoaded) {
                return _buildGroupList(context, state);
              }

              if (state is DeviceGroupError) {
                return Center(
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
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildGroupList(BuildContext context, DeviceGroupsLoaded state) {
    final theme = Theme.of(context);

    if (state.groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.folder_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Device Groups',
              style: AppTextStyles.headingSmall.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first device group',
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final bool? result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceGroupCreationPage(
                      familyId: familyId,
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  context
                      .read<DeviceGroupBloc>()
                      .add(const GetDeviceGroupsEvent());
                }
              },
              label: Text(
                'Create Group',
                style: AppTextStyles.buttonMedium,
              ),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DeviceGroupBloc>().add(const GetDeviceGroupsEvent());
      },
      color: theme.colorScheme.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: state.groups.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final group = state.groups[index];
          return DeviceGroupCard(
            group: group,
            onTap: () {
              AppRoutes.navigateToDeviceGroupDetail(context, group);
            },
            onEdit: () => AppRoutes.navigateToDeviceGroupDetail(context, group),
            onDelete: () => _handleDeleteGroup(context, group),
          );
        },
      ),
    );
  }
}
