import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_bloc.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_event.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_state.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  void _showErrorDialog(BuildContext context, String message) {
    MinimalDialog.show(
      context: context,
      title: 'Error',
      message: message,
      primaryButtonText: 'OK',
      type: DialogType.error,
      onPrimaryPressed: () {
        Navigator.pop(context);
        context.go(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingRemoteBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      )
        ..add(const LoadUserData())
        // ..add(const LoadSpotifyConnect())
        ..add(const LoadSetting()),
      child: BlocListener<LoadingRemoteBloc, LoadingRemoteState>(
        listener: (context, state) {
          if (state is LoadingRemoteSettingSuccess &&
              state.setting.familyName!.isNotEmpty) {
            log('state LoadingRemoteState: ${state.setting}');
            context.go(AppRoutes.landing);
          } else if (state is LoadingRemoteSettingSuccess &&
              state.setting.familyName!.isEmpty) {
            context.go(AppRoutes.createFamily);
          } else if (state is LoadingRemoteError) {
            _showErrorDialog(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or App Name
                Text(
                  'PiHome',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                // Loading Indicator
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Loading Text
                Text(
                  'Loading...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingPageProvider extends StatelessWidget {
  const LoadingPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingRemoteBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      )..add(const LoadUserData()),
      child: const LoadingPage(),
    );
  }
}
