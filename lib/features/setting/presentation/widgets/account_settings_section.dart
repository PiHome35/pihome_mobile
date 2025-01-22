import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_event.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_item.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_section.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: 'Account',
      child: BlocBuilder<UserLocalBloc, UserLocalState>(
        builder: (context, state) {
          String email = '';
          if (state is UserLocalInitial) {
            context.read<UserLocalBloc>().add(const GetCachedUserEvent());
          } else if (state is UserLocalLoaded) {
            email = state.user.email;
          } else {
            log('[getLocalUser] state: $state');
          }
          return SettingItem(
            title: 'Email',
            subtitle: email,
            trailing: IconButton(
              icon: const Icon(
                Icons.logout,
                size: 20,
              ),
              onPressed: () {
                log('logout');
                context.read<AuthBloc>().add(const LogoutEvent());

              },
            ),
          );
        },
      ),
    );
  }
}
