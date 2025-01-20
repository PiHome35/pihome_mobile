import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_group_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_group_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_group_state.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/device_group_card.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/device_group_form.dart';

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

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DeviceGroupForm(
            familyId: familyId,
            onSubmit: (name, deviceIds) {
              final group = DeviceGroupEntity(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                familyId: familyId,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(),
                deviceIds: deviceIds,
              );
              context
                  .read<DeviceGroupBloc>()
                  .add(CreateDeviceGroupEvent(group));
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, DeviceGroupEntity group) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DeviceGroupForm(
            familyId: familyId,
            initialGroup: group,
            onSubmit: (name, deviceIds) {
              final updatedGroup = DeviceGroupEntity(
                id: group.id,
                name: name,
                familyId: familyId,
                createdAt: group.createdAt,
                updatedAt: DateTime.now().toIso8601String(),
                deviceIds: deviceIds,
              );
              context
                  .read<DeviceGroupBloc>()
                  .add(UpdateDeviceGroupEvent(updatedGroup));
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Device Groups',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<DeviceGroupBloc, DeviceGroupState>(
        listener: (context, state) {
          if (state is DeviceGroupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state is DeviceGroupDeleted) {
            context.read<DeviceGroupBloc>().add(const GetDeviceGroupsEvent());
          }
        },
        builder: (context, state) {
          return switch (state) {
            DeviceGroupInitial() => const SizedBox.shrink(),
            DeviceGroupLoading() =>
              const Center(child: CircularProgressIndicator()),
            DeviceGroupsLoaded() => _buildGroupList(context, state),
            DeviceGroupLoaded() => const SizedBox.shrink(),
            DeviceGroupDeleted() => const SizedBox.shrink(),
            DeviceGroupError() => Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          };
        },
      ),
    );
  }

  Widget _buildGroupList(BuildContext context, DeviceGroupsLoaded state) {
    if (state.groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No device groups',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create a new group',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
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
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.groups.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final group = state.groups[index];
          return DeviceGroupCard(
            group: group,
            onTap: () {
              // TODO: Navigate to group details
            },
            onEdit: () => _showEditGroupDialog(context, group),
            onDelete: () => _handleDeleteGroup(context, group),
          );
        },
      ),
    );
  }
}
