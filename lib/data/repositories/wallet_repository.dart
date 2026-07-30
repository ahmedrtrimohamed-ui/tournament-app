import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../providers/api_provider.dart';

class WalletRepository {
  final ApiClient _apiClient;

  WalletRepository(this._apiClient);

  Future<Wallet> fetchWallet() async {
    final response = await _apiClient.get(ApiConstants.walletBalance);
    if (response.data != null) {
      return Wallet.fromJson(response.data);
    }
    // Return empty wallet if failed, or throw error depending on needs
    return Wallet(balance: 0.0, winnings: 0.0, deposited: 0.0, bonus: 0.0);
  }

  Future<List<Transaction>> fetchTransactions() async {
    final response = await _apiClient.get(ApiConstants.transactions);
    if (response.data != null && response.data is List) {
      return (response.data as List)
          .map((e) => Transaction.fromJson(e))
          .toList();
    }
    return [];
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletRepository(apiClient);
});
