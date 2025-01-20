import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_bloc.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_event.dart';
import 'package:mobile_pihome/features/loading/presentation/bloc/loading_remote_state.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingRemoteBloc(
        getIt(),
        getIt(),
        getIt(),
      )..add(const LoadUserData()),
      child: BlocListener<LoadingRemoteBloc, LoadingRemoteState>(
        listener: (context, state) {
          log('state: $state');
          if (state is LoadingRemoteSuccess) {
            if (state.user.familyId != null) {
              context.go(AppRoutes.landing);
            } else {
              context.go(AppRoutes.createFamily);
            }
          } else if (state is LoadingRemoteError) {
            context.go(AppRoutes.login);
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
      )..add(const LoadUserData()),
      child: const LoadingPage(),
    );
  }
}
