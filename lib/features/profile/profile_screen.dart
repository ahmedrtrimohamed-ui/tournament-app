import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/models/user_profile.dart';
import '../auth/providers/auth_provider.dart';
import 'providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY PROFILE'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => profile == null
            ? const Center(child: Text('Profile not found'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _ProfileHeader(profile: profile),
                    const SizedBox(height: 32),
                    _ProfileStats(profile: profile),
                    const SizedBox(height: 32),
                    _buildMenuItems(context),
                    const SizedBox(height: 48),
                    _LogoutButton(
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/login', (route) => false);
                        }
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        const _MenuItem(
          title: 'Edit Profile',
          icon: Icons.person_outline_rounded,
          onSubtitle: 'Personal info & avatar',
        ),
        const _MenuItem(
          title: 'KYC Verification',
          icon: Icons.verified_user_outlined,
          onSubtitle: 'Verify your ID for withdrawals',
          isVerified: true,
        ),
        const _MenuItem(
          title: 'Payment Methods',
          icon: Icons.credit_card_rounded,
          onSubtitle: 'Bank account, UPI, etc.',
        ),
        const _MenuItem(
          title: 'Transaction Logs',
          icon: Icons.history_edu_rounded,
          onSubtitle: 'Full history of your wallet',
        ),
        const _MenuItem(
          title: 'Terms & Conditions',
          icon: Icons.description_outlined,
          onSubtitle: 'Platform rules & guidelines',
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: profile.avatarUrl.isNotEmpty
                    ? NetworkImage(profile.avatarUrl)
                    : null,
                child: profile.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profile.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (profile.isVerified) ...[
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: AppColors.primary, size: 18),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '@${profile.username}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }
}

class _ProfileStats extends StatelessWidget {
  final UserProfile profile;
  const _ProfileStats({required this.profile});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      opacity: 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(
            label: 'Wins',
            value: '${profile.totalWins}',
            icon: Icons.military_tech_rounded,
            color: Colors.amber,
          ),
          _StatColumn(
            label: 'Matches',
            value: '${profile.totalMatches}',
            icon: Icons.sports_esports_rounded,
            color: AppColors.primary,
          ),
          _StatColumn(
            label: 'Earnings',
            value: '₹${profile.totalEarnings.toInt()}',
            icon: Icons.wallet_rounded,
            color: AppColors.success,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final String onSubtitle;
  final IconData icon;
  final bool isVerified;

  const _MenuItem({
    required this.title,
    required this.onSubtitle,
    required this.icon,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        opacity: 0.05,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 8),
                        const badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: AppColors.success,
                            elevation: 0,
                          ),
                          badgeContent: Text(
                            'VERIFIED',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    onSubtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LogoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
          SizedBox(width: 8),
          Text(
            'Log out of account',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}
