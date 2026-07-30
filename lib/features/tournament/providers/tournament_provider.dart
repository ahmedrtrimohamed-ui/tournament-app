import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/tournament.dart';
import '../../../data/repositories/tournament_repository.dart';

final tournamentListProvider = FutureProvider<List<Tournament>>((ref) async {
  final repository = ref.watch(tournamentRepositoryProvider);
  return repository.fetchTournaments();
});
