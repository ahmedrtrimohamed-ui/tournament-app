import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../auth/providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../navigation/main_navigation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Show splash for at least 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final authService = ref.read(authServiceProvider);
    final bool loggedIn = await authService.isAuthenticated();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              loggedIn ? const MainNavigation() : const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(
                          (255 * 0.15).toInt(),
                        ),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.5, 1.5),
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withAlpha((255 * 0.3).toInt()),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.sports_esports_rounded,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: 1200.ms,
                  )
                  .shimmer(
                    delay: 1500.ms,
                    duration: 1500.ms,
                    color: Colors.white24,
                  ),

              const SizedBox(height: 24),

              Text(
                    'TOUGAME',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      letterSpacing: 8,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 800.ms)
                  .slideY(begin: 0.3, end: 0)
                  .blurXY(begin: 10, end: 0, delay: 500.ms, duration: 800.ms),

              const SizedBox(height: 8),

              Text(
                'ULTIMATE ESPORTS PLATFORM',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 1.seconds, duration: 800.ms),
            ],
          ),

          Positioned(
            bottom: 60,
            child: Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary.withAlpha((255 * 0.5).toInt()),
                    ),
                  ),
                ).animate().fadeIn(delay: 1500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
