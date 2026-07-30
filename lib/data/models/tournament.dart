class Tournament {
  final String id;
  final String title;
  final String game;
  final String bannerUrl;
  final String prizePool;
  final String entryFee;
  final int participants;
  final int maxParticipants;
  final DateTime startTime;
  final bool isActive;

  Tournament({
    required this.id,
    required this.title,
    required this.game,
    required this.bannerUrl,
    required this.prizePool,
    required this.entryFee,
    required this.participants,
    required this.maxParticipants,
    required this.startTime,
    this.isActive = false,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      game: json['game'] ?? '',
      bannerUrl: json['banner_url'] ?? '',
      prizePool: json['prize_pool'] ?? '0',
      entryFee: json['entry_fee'] ?? '0',
      participants: json['participants_count'] ?? 0,
      maxParticipants: json['max_participants'] ?? 0,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : DateTime.now(),
      isActive: json['is_active'] ?? false,
    );
  }
}

final dummyTournaments = [
  Tournament(
    id: '1',
    title: 'PUBG Masters Invitational',
    game: 'PUBG Mobile',
    bannerUrl:
        'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070',
    prizePool: '₹50,000',
    entryFee: '₹100',
    participants: 84,
    maxParticipants: 100,
    startTime: DateTime.now().add(const Duration(hours: 2)),
    isActive: true,
  ),
  Tournament(
    id: '2',
    title: 'VALORANT Strike Force',
    game: 'Valorant',
    bannerUrl:
        'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=2070',
    prizePool: '₹25,000',
    entryFee: 'FREE',
    participants: 32,
    maxParticipants: 64,
    startTime: DateTime.now().add(const Duration(hours: 5)),
    isActive: true,
  ),
  Tournament(
    id: '3',
    title: 'Free Fire World Cup',
    game: 'Free Fire',
    bannerUrl:
        'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071',
    prizePool: '₹10,000',
    entryFee: '₹20',
    participants: 120,
    maxParticipants: 200,
    startTime: DateTime.now().add(const Duration(days: 1)),
    isActive: false,
  ),
];
