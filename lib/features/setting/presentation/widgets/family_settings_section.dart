import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_bloc.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_event.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_item.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_section.dart';

class FamilySettingsSection extends StatelessWidget {
  final String familyName;
  
  // final FamilySettingState familySettingState;

  const FamilySettingsSection({
    super.key,
    required this.familyName,
    // required this.userState,
    // required this.familySettingState,
  });

  @override
  Widget build(BuildContext context) {
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
          // if (familySettingState is FamilySettingStateSuccess) {
          //   if (familySettingState.family?.ownerId == user.id) {
          //     AppRoutes.navigateToFamilySettings(context);
          //   }
          // }
        },
      ),
    );
  }
}
