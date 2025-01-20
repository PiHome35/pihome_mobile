import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';

enum DialogType {
  normal,
  caution,
  success,
  error,
}

class MinimalDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool showCloseButton;
  final DialogType type;
  final IconData? icon;

  const MinimalDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.showCloseButton = true,
    this.type = DialogType.normal,
    this.icon,
  });

  Color get _iconColor {
    switch (type) {
      case DialogType.caution:
        return Colors.orange;
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  IconData get _defaultIcon {
    switch (type) {
      case DialogType.caution:
        return Icons.warning_rounded;
      case DialogType.success:
        return Icons.check_circle_rounded;
      case DialogType.error:
        return Icons.error_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Widget _buildButtons(BuildContext context) {
    if (type == DialogType.caution) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (secondaryButtonText != null) ...[
            TextButton(
              onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              child: Text(
                secondaryButtonText!,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: ElevatedButton(
              onPressed: onPrimaryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                primaryButtonText,
                style: AppTextStyles.buttonMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.end,
      children: [
        if (secondaryButtonText != null)
          TextButton(
            onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            child: Text(
              secondaryButtonText!,
              style: AppTextStyles.buttonMedium.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ),
        ElevatedButton(
          onPressed: onPrimaryPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 12.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            primaryButtonText,
            style: AppTextStyles.buttonMedium,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400.w,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCloseButton) ...[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: Colors.grey[600],
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
              if (type != DialogType.normal) ...[
                Icon(
                  icon ?? _defaultIcon,
                  size: 32.sp,
                  color: _iconColor,
                ),
                SizedBox(height: 16.h),
              ],
              Text(
                title,
                style: AppTextStyles.headingSmall,
              ),
              SizedBox(height: 16.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool showCloseButton = true,
    DialogType type = DialogType.normal,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => MinimalDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed:
            onPrimaryPressed ?? () => Navigator.pop(context, true),
        onSecondaryPressed: onSecondaryPressed,
        showCloseButton: showCloseButton,
        type: type,
        icon: icon,
      ),
    );
  }
}
