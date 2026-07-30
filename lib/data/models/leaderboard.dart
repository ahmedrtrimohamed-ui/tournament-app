class LeaderboardEntry {
  final String username;
  final int rank;
  final int points;
  final String avatarUrl;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.username,
    required this.rank,
    required this.points,
    required this.avatarUrl,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      username: json['username'] ?? 'Gamer',
      rank: json['rank'] ?? 0,
      points: json['points'] ?? 0,
      avatarUrl: json['avatar_url'] ?? '',
      isCurrentUser: json['is_current_user'] ?? false,
    );
  }
}
