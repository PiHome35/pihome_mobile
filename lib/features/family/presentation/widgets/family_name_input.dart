import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_bloc.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_event.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_state.dart';

class FamilyNameInput extends StatelessWidget {
  const FamilyNameInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyBloc, FamilyState>(
      buildWhen: (previous, current) =>
          previous.familyName != current.familyName,
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            labelText: 'Family Name',
            labelStyle: AppTextStyles.inputLabel,
            hintText: 'Enter your family name',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(Icons.family_restroom),
            errorStyle: AppTextStyles.error,
            errorText: state.familyName.displayError?.message,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          onChanged: (value) {
            context.read<FamilyBloc>().add(FamilyNameChanged(value));
          },
        );
      },
    );
  }
}
