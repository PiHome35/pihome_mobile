import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_event.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_state.dart';
import 'package:mobile_pihome/features/authentication/presentation/widgets/dot_loading.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<AuthBloc>();
        bloc.add(const CheckAuth());
        return bloc;
      },
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        log('listener state.status [checkAuth] ${state.status}');
        if (state.status == FormzSubmissionStatus.success) {
          context.go(AppRoutes.loading);
        } else if (state.status == FormzSubmissionStatus.initial) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PiHome',
                style: AppTextStyles.headingLarge.copyWith(
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              const DotLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
