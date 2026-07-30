import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/models/leaderboard.dart';
import 'providers/leaderboard_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LEADERBOARD'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: leaderboardAsync.when(
        data: (entries) => entries.isEmpty
            ? const Center(
                child: Text(
                  'No entries found.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 20),
                  _PodiumUI(
                    entries: entries.sublist(
                      0,
                      entries.length >= 3 ? 3 : entries.length,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: entries.length > 3 ? entries.length - 3 : 0,
                      itemBuilder: (context, index) {
                        final entry = entries[index + 3];
                        return _LeaderboardRow(entry: entry)
                            .animate()
                            .fadeIn(delay: (300 + (index * 50)).ms)
                            .slideX(begin: 0.1);
                      },
                    ),
                  ),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _PodiumUI extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  const _PodiumUI({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox();
    final first = entries.first;
    final second = entries.length >= 2 ? entries[1] : null;
    final third = entries.length >= 3 ? entries[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          _PodiumItem(
            rank: 2,
            name: second.username,
            points: second.points.toString(),
            height: 130,
            color: Colors.grey,
            avatar: second.avatarUrl,
          ),
        const SizedBox(width: 16),
        _PodiumItem(
          rank: 1,
          name: first.username,
          points: first.points.toString(),
          height: 160,
          color: Colors.amber,
          isCenter: true,
          avatar: first.avatarUrl,
        ),
        const SizedBox(width: 16),
        if (third != null)
          _PodiumItem(
            rank: 3,
            name: third.username,
            points: third.points.toString(),
            height: 110,
            color: Colors.brown,
            avatar: third.avatarUrl,
          ),
      ],
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }
}

class _PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final double height;
  final Color color;
  final bool isCenter;
  final String avatar;

  const _PodiumItem({
    required this.rank,
    required this.name,
    required this.points,
    required this.height,
    required this.color,
    this.isCenter = false,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isCenter ? 3 : 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: isCenter ? 3 : 2),
              ),
              child: CircleAvatar(
                radius: isCenter ? 40 : 30,
                backgroundImage: avatar.isNotEmpty
                    ? NetworkImage(avatar)
                    : null,
                child: avatar.isEmpty ? const Icon(Icons.person) : null,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isCenter ? 14 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          points,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: isCenter ? 14 : 12,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: isCenter ? 90 : 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withAlpha(102), color.withAlpha(25)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(color: color.withAlpha(76)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.military_tech, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                rank == 1 ? 'MVP' : 'TOP $rank',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  const _LeaderboardRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        opacity: entry.isCurrentUser ? 0.15 : 0.05,
        color: entry.isCurrentUser ? AppColors.primary : Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '${entry.rank}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: entry.avatarUrl.isNotEmpty
                  ? NetworkImage(entry.avatarUrl)
                  : null,
              child: entry.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                entry.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (entry.isCurrentUser)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'YOU',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            const SizedBox(width: 16),
            Text(
              '${entry.points} pts',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
