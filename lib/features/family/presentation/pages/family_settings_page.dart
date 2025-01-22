import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_bloc.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_event.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_state.dart';

class FamilySettingsPage extends StatefulWidget {
  const FamilySettingsPage({super.key});

  @override
  State<FamilySettingsPage> createState() => _FamilySettingsPageState();
}

class _FamilySettingsPageState extends State<FamilySettingsPage> {
  @override
  void initState() {
    super.initState();
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
          'Family Settings',
          style: AppTextStyles.headingMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<FamilySettingBloc>()
          ..add(
            const FetchFamilySettingDetail(),
          ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Family Information',
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: BlocBuilder<FamilySettingBloc, FamilySettingState>(
                  builder: (context, state) {
                    log('state in family settings: $state');
                    if (state is! FamilySettingStateSuccess &&
                        state is! FamilyInviteCodeStateSuccess) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Family Name',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              state.family?.name ?? 'Loading...',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Members',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              '${state.users?.length ?? 0} members',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Invite Code',
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: BlocConsumer<FamilySettingBloc, FamilySettingState>(
                  listener: (context, state) {
                    if (state is FamilyInviteCodeStateFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ?? 'An error occurred',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: theme.colorScheme.onError,
                            ),
                          ),
                          backgroundColor: theme.colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is! FamilySettingStateSuccess &&
                        state is! FamilyInviteCodeStateSuccess) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final hasInviteCode = state.family?.inviteCode != null &&
                        state.family!.inviteCode!.isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state is FamilyInviteCodeStateSuccess ||
                            hasInviteCode) ...[
                          Text(
                            'Share this code with family members',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    state is FamilyInviteCodeStateSuccess
                                        ? state.inviteCode ?? ''
                                        : state.family?.inviteCode ?? '',
                                    style: AppTextStyles.headingSmall.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.copy,
                                    color: theme.colorScheme.onSurface,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    final codeToShare =
                                        state is FamilyInviteCodeStateSuccess
                                            ? state.inviteCode
                                            : state.family?.inviteCode;

                                    if (codeToShare != null) {
                                      await Clipboard.setData(
                                        ClipboardData(text: codeToShare),
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Invite code copied to clipboard',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                              ),
                                            ),
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ] else if (state is FamilyInviteCodeStateLoading) ...[
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Generate an invite code to add family members',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: state is FamilyInviteCodeStateLoading
                                ? null
                                : () async {
                                    if (state is FamilyInviteCodeStateSuccess ||
                                        hasInviteCode) {
                                      final confirmed =
                                          await MinimalDialog.show(
                                        context: context,
                                        title: 'Generate New Code',
                                        message:
                                            'This will invalidate the current invite code. Are you sure you want to continue?',
                                        primaryButtonText: 'Generate New',
                                        secondaryButtonText: 'Cancel',
                                        type: DialogType.caution,
                                      );

                                      if (confirmed == true &&
                                          context.mounted) {
                                        context.read<FamilySettingBloc>().add(
                                              const FamilyInviteCodePressed(),
                                            );
                                      }
                                    } else {
                                      context.read<FamilySettingBloc>().add(
                                            const FamilyInviteCodePressed(),
                                          );
                                    }
                                  },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              state is FamilyInviteCodeStateSuccess ||
                                      hasInviteCode
                                  ? 'Generate New Code'
                                  : 'Generate Code',
                              style: AppTextStyles.buttonMedium.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
