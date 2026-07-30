// lib/data/providers/storage_provider.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(ApiConstants.tokenKey, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(ApiConstants.refreshKey, token);
  }

  String? getToken() {
    return _prefs.getString(ApiConstants.tokenKey);
  }

  String? getRefreshToken() {
    return _prefs.getString(ApiConstants.refreshKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(ApiConstants.tokenKey);
  }

  Future<void> removeRefreshToken() async {
    await _prefs.remove(ApiConstants.refreshKey);
  }
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final storageProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return StorageService(prefs);
});
