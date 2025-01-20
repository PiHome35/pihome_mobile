import 'package:flutter/material.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/graphql/graph_exception.dart';

class ErrorStateWidget extends StatelessWidget {
  final GraphQLException error;
  final VoidCallback onRetry;
  final String? retryText;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.retryText,
  });

  IconData get _icon {
    return switch (error.type) {
      GraphQLErrorType.network => Icons.wifi_off_rounded,
      GraphQLErrorType.auth => Icons.lock_outline_rounded,
      GraphQLErrorType.notFound => Icons.search_off_rounded,
      GraphQLErrorType.server => Icons.cloud_off_rounded,
      GraphQLErrorType.validation => Icons.error_outline_rounded,
      GraphQLErrorType.subscription => Icons.sync_problem_rounded,
      GraphQLErrorType.unknown => Icons.error_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icon,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              error.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                retryText ?? 'Retry',
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
