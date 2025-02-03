import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';

class AIModelSelectionPage extends StatelessWidget {
  final List<ChatAiModelEntity> chatModels;
  const AIModelSelectionPage({super.key, required this.chatModels});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // bool isUpdate = false;

    return BlocProvider(
      create: (context) => getIt<SettingBloc>()..add(const GetSettingEvent()),
      child: AiModelSelectionView(
        theme: theme,
        chatModels: chatModels,
      ),
    );
  }
}

class AiModelSelectionView extends StatefulWidget {
  const AiModelSelectionView({
    super.key,
    required this.theme,
    required this.chatModels,
    // this.isUpdate = false,
  });

  final ThemeData theme;
  final List<ChatAiModelEntity> chatModels;
  // final bool isUpdate;

  @override
  State<AiModelSelectionView> createState() => _AiModelSelectionViewState();
}

class _AiModelSelectionViewState extends State<AiModelSelectionView> {
  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop(isUpdate);
            },
          ),
          title: Text(
            'Select AI Model',
            style: AppTextStyles.headingMedium.copyWith(
              color: widget.theme.colorScheme.onSurface,
            ),
          ),
        ),
        body: BlocConsumer<SettingBloc, SettingState>(
          listener: (context, state) {
            if (state is SettingLoaded && state.isModelUpdateSuccess == true) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  dismissDirection: DismissDirection.horizontal,
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  backgroundColor: widget.theme.colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  content: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color:
                              widget.theme.colorScheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: widget.theme.colorScheme.primary,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Model Updated',
                              style: AppTextStyles.labelLarge.copyWith(
                                color:
                                    widget.theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Your AI model preference has been saved',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: widget
                                    .theme.colorScheme.onPrimaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              setState(() {
                isUpdate = true;
              });
            }
          },
          builder: (context, state) {
            if (state is SettingLoaded) {
              final currentModel = state.setting.selectedLLMModel;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: widget.chatModels.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final model = widget.chatModels[index];
                  final isSelected = model.id == currentModel;

                  return _AIModelCard(
                    model: model,
                    isSelected: isSelected,
                    onTap: () {
                      context
                          .read<SettingBloc>()
                          .add(UpdateSelectedAiModelEvent(model.id, model.key));
                    },
                  );
                },
              );
            }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _AIModelCard extends StatelessWidget {
  final ChatAiModelEntity model;
  final bool isSelected;
  final VoidCallback onTap;

  const _AIModelCard({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: isSelected ? 2 : 0,
        shadowColor: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.3)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.12),
            width: isSelected ? 1 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.05)
                  : theme.colorScheme.surface,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              model.name,
                              style: AppTextStyles.headingSmall.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                                fontSize: 18.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: theme.colorScheme.primary,
                                    size: 16.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Active',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        model.key,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.8)
                              : theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            width: 2,
                          ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          color: theme.colorScheme.onPrimary,
                          size: 20.w,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
