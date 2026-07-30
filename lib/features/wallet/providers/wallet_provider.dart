import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/wallet.dart';
import '../../../data/repositories/wallet_repository.dart';

final walletBalanceProvider = FutureProvider<Wallet>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.fetchWallet();
});

final transactionListProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.fetchTransactions();
});
