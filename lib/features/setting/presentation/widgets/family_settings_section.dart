import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_bloc.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_event.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_item.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_section.dart';

class FamilySettingsSection extends StatelessWidget {
  final String familyName;
  final String userId;

  const FamilySettingsSection({
    super.key,
    required this.familyName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FamilySettingBloc>(
      create: (context) =>
          getIt<FamilySettingBloc>()..add(const FetchFamilySettingDetail()),
      child: BlocBuilder<FamilySettingBloc, FamilySettingState>(
        builder: (context, state) {
          return SettingSection(
            title: 'Family',
            child: SettingItem(
              title: 'Family Name',
              subtitle: familyName,
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () {
                log('userId: $userId');
                log('state.family?.ownerId: ${state.family?.ownerId}');
                if (state is FamilySettingStateSuccess) {
                  if (state.family?.ownerId == userId) {
                    AppRoutes.navigateToFamilySettings(context);
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
