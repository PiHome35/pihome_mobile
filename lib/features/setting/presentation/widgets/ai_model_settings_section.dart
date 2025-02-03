import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_item.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_section.dart';
import 'package:mobile_pihome/features/setting/presentation/pages/setting_ai_model_selection.dart';

class AIModelSettingsSection extends StatelessWidget {
  final List<ChatAiModelEntity> chatModels;
  final SettingBloc settingBloc;
  const AIModelSettingsSection({
    super.key,
    required this.chatModels,
    required this.settingBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      bloc: settingBloc,
      // buildWhen: (previous, current) => current is SettingLoaded,
      builder: (context, state) {
        if (state is SettingLoaded) {
          final currentModelId = state.setting.selectedLLMModel;
          final currentModel = chatModels.firstWhere(
            (model) => model.id == currentModelId,
            orElse: () => ChatAiModelEntity(
              id: currentModelId,
              key: currentModelId,
              name: currentModelId,
              createdAt: DateTime.now().toIso8601String(),
              updatedAt: DateTime.now().toIso8601String(),
            ),
          );

          return SettingSection(
            title: 'AI Model',
            child: SettingItem(
              title: 'Selected Model',
              subtitle: currentModel.name,
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
              ),
              onTap: () async {
                final wasUpdated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AIModelSelectionPage(chatModels: chatModels),
                  ),
                );

                // Refresh settings
                settingBloc
                  ..add(const GetSettingEvent())
                  ..add(const GetChatAiModelsEvent());
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
