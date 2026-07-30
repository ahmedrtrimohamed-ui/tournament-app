import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/leaderboard.dart';
import '../../../data/repositories/leaderboard_repository.dart';

final leaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  final repository = ref.watch(leaderboardRepositoryProvider);
  return repository.fetchGlobalLeaderboard();
});
