import 'package:flutter/material.dart';
import 'minimal_dialog.dart';

class DialogHelpers {
  static Future<bool?> showCautionDialog({
    required BuildContext context,
    required String title,
    required String message,
    String primaryButtonText = 'Continue',
    String? secondaryButtonText = 'Cancel',
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool showCloseButton = false,
    IconData? icon,
  }) {
    return MinimalDialog.show(
      context: context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      showCloseButton: showCloseButton,
      type: DialogType.caution,
      icon: icon,
    );
  }

  static Future<bool?> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String primaryButtonText = 'OK',
    VoidCallback? onPrimaryPressed,
    bool showCloseButton = true,
    IconData? icon,
  }) {
    return MinimalDialog.show(
      context: context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      showCloseButton: showCloseButton,
      type: DialogType.success,
      icon: icon,
    );
  }

  static Future<bool?> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String primaryButtonText = 'OK',
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool showCloseButton = true,
    IconData? icon,
  }) {
    return MinimalDialog.show(
      context: context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      showCloseButton: showCloseButton,
      type: DialogType.error,
      icon: icon,
    );
  }
}
