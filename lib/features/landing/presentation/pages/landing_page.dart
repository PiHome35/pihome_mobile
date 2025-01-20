import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/core/widgets/custom_bottom_navigation.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/chat_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_page.dart';
import 'package:mobile_pihome/features/landing/presentation/bloc/landing_bloc.dart';
import 'package:mobile_pihome/features/landing/presentation/bloc/landing_event.dart';
import 'package:mobile_pihome/features/landing/presentation/bloc/landing_state.dart';
import 'package:mobile_pihome/features/setting/presentation/pages/setting_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LandingBloc>(),
      child: const LandingView(),
    );
  }
}

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingBloc, LandingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: state.currentIndex,
            children: const [
              DevicePage(),
              ChatPage(),
              SettingPage(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<LandingBloc>().add(TabChanged(index));
            },
          ),
        );
      },
    );
  }
}
