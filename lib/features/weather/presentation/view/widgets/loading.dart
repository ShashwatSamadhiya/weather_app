part of weather_app;

class WeatherLoadingScreen extends StatefulWidget {
  final String loadingMessage;
  const WeatherLoadingScreen({
    super.key,
    this.loadingMessage = "Loading...",
  });

  @override
  State<WeatherLoadingScreen> createState() => _WeatherLoadingScreenState();
}

class _WeatherLoadingScreenState extends State<WeatherLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late Timer _iconTimer;
  int _iconIndex = 0;

  final List<IconData> _weatherIcons = [
    Icons.wb_sunny,
    Icons.cloud,
    Icons.thunderstorm,
  ];

  @override
  void initState() {
    super.initState();

    // Continuous rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Pulsing glow
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.7,
      upperBound: 1.2,
    )..repeat(reverse: true);

    _iconTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _iconIndex = (_iconIndex + 1) % _weatherIcons.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _glowController.dispose();
    _iconTimer.cancel();
    super.dispose();
  }

  Widget buildLoadingText(BuildContext context) {
    return Text(
      widget.loadingMessage,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _rotationController,
              child: ScaleTransition(
                scale: _glowController,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  ),
                  child: Icon(
                    _weatherIcons[_iconIndex],
                    color: theme.colorScheme.primary,
                    size: 90,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildLoadingText(context),
          ],
        ),
      ),
    );
  }
}
