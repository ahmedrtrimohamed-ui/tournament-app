class Wallet {
  final double balance; // available_balance from Django
  final double holdBalance; // hold_balance from Django
  final double winnings;
  final double deposited;
  final double bonus;

  Wallet({
    required this.balance,
    this.holdBalance = 0.0,
    this.winnings = 0.0,
    this.deposited = 0.0,
    this.bonus = 0.0,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance:
          double.tryParse(json['available_balance']?.toString() ?? '0') ?? 0.0,
      holdBalance:
          double.tryParse(json['hold_balance']?.toString() ?? '0') ?? 0.0,
      winnings: double.tryParse(json['winnings']?.toString() ?? '0') ?? 0.0,
      deposited: double.tryParse(json['deposited']?.toString() ?? '0') ?? 0.0,
      bonus: double.tryParse(json['bonus']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime createdAt;
  final String status;
  final String type; // 'CREDIT' or 'DEBIT'

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      title: json['title'] ?? 'Transaction',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      status: json['status'] ?? 'SUCCESS',
      type: json['transaction_type'] ?? 'DEBIT',
    );
  }
}
