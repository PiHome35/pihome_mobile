import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/dialog_helpers.dart';
import '../bloc/family_bloc.dart';
import '../bloc/family_event.dart';
import '../bloc/family_state.dart';
import '../widgets/family_name_input.dart';

class CreateFamilyPage extends StatelessWidget {
  const CreateFamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocProvider(
        create: (_) => getIt<FamilyBloc>(),
        child: const CreateFamilyView(),
      ),
    );
  }
}

class CreateFamilyView extends StatefulWidget {
  const CreateFamilyView({super.key});

  @override
  State<CreateFamilyView> createState() => _CreateFamilyViewState();
}

class _CreateFamilyViewState extends State<CreateFamilyView> {
  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSkip() async {
    final result = await DialogHelpers.showCautionDialog(
      context: context,
      title: 'Limited Access',
      message:
          'Without creating a family, you\'ll have limited access to features. Some functionalities may not be available. You can create a family later from your profile settings.',
      primaryButtonText: 'Continue',
      secondaryButtonText: 'Go Back',
    );

    if (result == true && mounted) {
      context.go(AppRoutes.landing);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilyBloc, FamilyState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Failed to create family',
                  style: AppTextStyles.error,
                ),
                backgroundColor: Colors.red[400],
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
        if (state.status.isSuccess) {
          context.go(AppRoutes.loading);
        }
      },
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Family',
                    style: AppTextStyles.headingLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a family group to unlock the full potential of all features.',
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(height: 48),
                  FamilyNameInput(controller: _familyNameController),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context
                                  .read<FamilyBloc>()
                                  .add(const CreateFamilySubmitted());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Create Family',
                            style: AppTextStyles.buttonLarge,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go(AppRoutes.joinFamily);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Join Family',
                            style: AppTextStyles.buttonLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: TextButton(
                      onPressed: _handleSkip,
                      child: Text(
                        'Skip for now',
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyBloc, FamilyState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state.status.isInProgress
                ? null
                : () {
                    if (formKey.currentState?.validate() ?? false) {
                      context
                          .read<FamilyBloc>()
                          .add(const CreateFamilySubmitted());
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: state.status.isInProgress
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Create Family',
                    style: AppTextStyles.buttonLarge,
                  ),
          ),
        );
      },
    );
  }
}
