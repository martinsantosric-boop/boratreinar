enum League {
  bronze,
  silver,
  gold,
  diamond,
  legendary;

  String get displayName {
    switch (this) {
      case League.bronze:
        return 'Bronze';
      case League.silver:
        return 'Prata';
      case League.gold:
        return 'Ouro';
      case League.diamond:
        return 'Diamante';
      case League.legendary:
        return 'Lendária';
    }
  }

  String get emoji {
    switch (this) {
      case League.bronze:
        return '🥉';
      case League.silver:
        return '🥈';
      case League.gold:
        return '🥇';
      case League.diamond:
        return '💎';
      case League.legendary:
        return '👑';
    }
  }

  int get minXp {
    switch (this) {
      case League.bronze:
        return 0;
      case League.silver:
        return 1000;
      case League.gold:
        return 3000;
      case League.diamond:
        return 7000;
      case League.legendary:
        return 15000;
    }
  }

  int? get nextLevelXp {
    switch (this) {
      case League.bronze:
        return 1000;
      case League.silver:
        return 3000;
      case League.gold:
        return 7000;
      case League.diamond:
        return 15000;
      case League.legendary:
        return null; // Max level
    }
  }

  static League fromXp(int xp) {
    if (xp >= 15000) return League.legendary;
    if (xp >= 7000) return League.diamond;
    if (xp >= 3000) return League.gold;
    if (xp >= 1000) return League.silver;
    return League.bronze;
  }
}
