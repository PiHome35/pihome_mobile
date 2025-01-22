import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_state.dart';
import '../bloc/family_bloc.dart';
import '../bloc/family_event.dart';

class JoinFamilyPage extends StatefulWidget {
  const JoinFamilyPage({super.key});

  @override
  State<JoinFamilyPage> createState() => _JoinFamilyPageState();
}

class _JoinFamilyPageState extends State<JoinFamilyPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FamilyBloc>(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            log('state in join family: $state');
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Join Family',
                    style: AppTextStyles.headingLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter the invitation code to join a family.',
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _inviteCodeController,
                    decoration: InputDecoration(
                      labelText: 'Invitation Code',
                      labelStyle: AppTextStyles.inputLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style: AppTextStyles.input,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<FamilyBloc>().add(JoinFamilySubmitted(
                            inviteCode: _inviteCodeController.text));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text('Join', style: AppTextStyles.buttonLarge),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.go(AppRoutes.createFamily);
                      },
                      child: Text(
                        'Back to Create Family',
                        style: AppTextStyles.buttonMedium.copyWith(
                            color: Colors.black.withValues(
                          alpha: 0.5,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  final _inviteCodeController = TextEditingController();

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }
}
