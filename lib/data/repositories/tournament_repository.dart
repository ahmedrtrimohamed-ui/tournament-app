import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tournament.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../providers/api_provider.dart';

class TournamentRepository {
  final ApiClient _apiClient;

  TournamentRepository(this._apiClient);

  Future<List<Tournament>> fetchTournaments() async {
    final response = await _apiClient.get(ApiConstants.tournaments);

    if (response.data != null && response.data is List) {
      final List<dynamic> list = response.data;
      if (list.isNotEmpty) {
        return list.map((e) => Tournament.fromJson(e)).toList();
      }
    }
    return dummyTournaments;
  }

  Future<void> joinTournament(String id) async {
    final path = ApiConstants.joinTournament.replaceAll('{id}', id);
    await _apiClient.post(path);
  }

  Future<void> cancelParticipation(String id) async {
    final path = ApiConstants.joinTournament.replaceAll('{id}', id);
    await _apiClient.delete(path);
  }
}

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TournamentRepository(apiClient);
});
