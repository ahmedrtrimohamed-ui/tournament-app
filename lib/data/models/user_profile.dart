class UserProfile {
  final String id;
  final String name;
  final String email;
  final String username;
  final String avatarUrl;
  final int totalWins;
  final int totalMatches;
  final double totalEarnings;
  final bool isVerified;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.avatarUrl,
    required this.totalWins,
    required this.totalMatches,
    required this.totalEarnings,
    this.isVerified = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Gamer',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      totalWins: json['total_wins'] ?? 0,
      totalMatches: json['total_matches'] ?? 0,
      totalEarnings:
          double.tryParse(json['total_earnings']?.toString() ?? '0') ?? 0.0,
      isVerified: json['is_verified'] ?? false,
    );
  }
}
