import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/leaderboard.dart';
import '../../core/network/api_client.dart';
import '../providers/api_provider.dart';

class LeaderboardRepository {
  final ApiClient _apiClient;

  LeaderboardRepository(this._apiClient);

  Future<List<LeaderboardEntry>> fetchGlobalLeaderboard() async {
    // For demo, using tournaments leaderboard endpoint or separate global one
    final response = await _apiClient.get('/tournaments/global_leaderboard/');
    if (response.data != null && response.data is List) {
      return (response.data as List)
          .map((e) => LeaderboardEntry.fromJson(e))
          .toList();
    }
    return [];
  }
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaderboardRepository(apiClient);
});
