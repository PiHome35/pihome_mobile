import 'package:flutter/material.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

class DeviceGroupForm extends StatefulWidget {
  final DeviceGroupEntity? initialGroup;
  final String familyId;
  final Function(String name, List<DeviceEntity> devices) onSubmit;

  const DeviceGroupForm({
    super.key,
    this.initialGroup,
    required this.familyId,
    required this.onSubmit,
  });

  @override
  State<DeviceGroupForm> createState() => _DeviceGroupFormState();
}

class _DeviceGroupFormState extends State<DeviceGroupForm> {
  late final TextEditingController _nameController;
  final Set<DeviceEntity> _selectedDevices = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialGroup?.name);
    if (widget.initialGroup != null) {
      _selectedDevices.addAll(widget.initialGroup!.devices);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_nameController.text, _selectedDevices.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.initialGroup != null ? 'Edit Group' : 'Create Group',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            style: AppTextStyles.input,
            decoration: InputDecoration(
              labelText: 'Group Name',
              labelStyle: AppTextStyles.inputLabel,
              hintText: 'Enter group name',
              hintStyle: AppTextStyles.inputHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a group name';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Selected Devices',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 8),
          // TODO: Add device selection list
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _handleSubmit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.initialGroup != null ? 'Update Group' : 'Create Group',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }
}
