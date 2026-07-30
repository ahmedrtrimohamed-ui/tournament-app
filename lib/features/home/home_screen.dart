import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/models/tournament.dart';
import '../tournament/tournament_detail_screen.dart';
import '../tournament/providers/tournament_provider.dart';
import '../profile/providers/profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentListProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(tournamentListProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HomeHeader(),
                const SizedBox(height: 20),
                tournamentsAsync.when(
                  data: (tournaments) =>
                      _FeaturedCarousel(tournaments: tournaments),
                  loading: () => const _CarouselLoading(),
                  error: (_, __) => const _FeaturedCarousel(tournaments: []),
                ),
                const SizedBox(height: 30),
                const _PrizePoolHighlights(),
                const SizedBox(height: 30),
                _SectionHeader(title: 'Active Tournaments', onSeeAll: () {}),
                const SizedBox(height: 16),
                tournamentsAsync.when(
                  data: (tournaments) => tournaments.isEmpty
                      ? const Center(
                          child: Text(
                            'No tournaments found',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (tournaments.length >= 2)
                              ? 2
                              : tournaments.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            return TournamentCard(
                              tournament: tournaments[index],
                            );
                          },
                        ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (err, stack) => Center(
                    child: Text(
                      'Error: $err',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _SectionHeader(title: 'Upcoming Tournaments', onSeeAll: () {}),
                const SizedBox(height: 16),
                tournamentsAsync.when(
                  data: (tournaments) => tournaments.length > 2
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tournaments.length - 2,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            return TournamentCard(
                              tournament: tournaments[index + 2],
                            );
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No upcoming tournaments',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                  loading: () => const SizedBox(),
                  error: (err, stack) => const SizedBox(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselLoading extends StatelessWidget {
  const _CarouselLoading();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HELLO GAMER,',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              profileAsync.when(
                data: (profile) => Text(
                  profile?.name ?? 'Gamer',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                loading: () =>
                    Container(height: 24, width: 100, color: Colors.white10),
                error: (_, __) => Text(
                  'Gamer',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          profileAsync.when(
            data: (profile) => CircleAvatar(
              radius: 24,
              backgroundImage:
                  (profile?.avatarUrl != null && profile!.avatarUrl.isNotEmpty)
                  ? NetworkImage(profile.avatarUrl)
                  : null,
              child: (profile?.avatarUrl == null || profile!.avatarUrl.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
              backgroundColor: AppColors.cardBg,
            ),
            loading: () =>
                const CircleAvatar(radius: 24, backgroundColor: Colors.white10),
            error: (_, __) =>
                const CircleAvatar(radius: 24, child: Icon(Icons.person)),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
    );
  }
}

class _FeaturedCarousel extends StatelessWidget {
  final List<Tournament> tournaments;
  const _FeaturedCarousel({required this.tournaments});

  @override
  Widget build(BuildContext context) {
    final displayTournaments = tournaments.isEmpty
        ? dummyTournaments
        : tournaments;

    return cs.CarouselSlider(
      options: cs.CarouselOptions(
        height: 180.0,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 0.85,
      ),
      items: displayTournaments.map((tournament) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TournamentDetailScreen(tournament: tournament),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: NetworkImage(tournament.bannerUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withAlpha((255 * 0.7).toInt()),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'MEGA PRIZE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tournament.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        tournament.game,
                        style: TextStyle(
                          color: Colors.white.withAlpha((255 * 0.8).toInt()),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9));
  }
}

class _PrizePoolHighlights extends StatelessWidget {
  const _PrizePoolHighlights();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatsCard(
            label: 'TODAY\'S PRIZE',
            value: '₹2.5L+',
            icon: Icons.emoji_events_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(width: 16),
          _StatsCard(
            label: 'MATCHES',
            value: '450+',
            icon: Icons.sports_esports_rounded,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 16),
          _StatsCard(
            label: 'PLAYERS',
            value: '1.2K+',
            icon: Icons.people_alt_rounded,
            color: AppColors.success,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1);
  }
}

class _StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 150,
      padding: const EdgeInsets.all(16),
      opacity: 0.08,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'View All',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class TournamentCard extends StatelessWidget {
  final Tournament tournament;

  const TournamentCard({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: EdgeInsets.zero,
        opacity: 0.05,
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'tournament_${tournament.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      tournament.bannerUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    borderRadius: 8,
                    opacity: 0.6,
                    color: Colors.black,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.people_alt,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${tournament.participants}/${tournament.maxParticipants}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tournament.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              tournament.game,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.textMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Starts in 2h',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'PRIZE POOL',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        tournament.prizePool,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.1).toInt()),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            tournament.participants /
                            tournament.maxParticipants,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(
                                  (255 * 0.5).toInt(),
                                ),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TournamentDetailScreen(tournament: tournament),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(
                            (255 * 0.3).toInt(),
                          ),
                        ),
                      ),
                      child: const Text(
                        'JOIN',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 600.ms).slideY(begin: 0.1);
  }
}
