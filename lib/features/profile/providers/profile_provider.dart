import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_profile.dart';
import '../../auth/providers/auth_provider.dart';

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final service = ref.watch(authServiceProvider);
  return service.fetchProfile();
});
