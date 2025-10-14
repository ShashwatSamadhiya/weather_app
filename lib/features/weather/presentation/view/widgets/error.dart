part of weather_app;

class ErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  Widget retryButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onRetry,
      icon: const Icon(
        Icons.refresh,
        color: Colors.black,
      ),
      label: const Text("Retry"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget errorMessageWidget(BuildContext context) {
    return Text(
      errorMessage,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: .7),
          ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 90,
              ),
              const SizedBox(height: 20),
              errorMessageWidget(context),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                retryButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
