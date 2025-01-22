import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_item.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_section.dart';

class AIModelSettingsSection extends StatelessWidget {
  const AIModelSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is SettingLoaded,
      builder: (context, state) {
        if (state is SettingLoaded) {
          return SettingSection(
            title: 'AI Model',
            child: SettingItem(
              title: 'Selected Model',
              subtitle: state.setting.selectedLLMModel,
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
            onTap: () {
            },
          ),
        );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

