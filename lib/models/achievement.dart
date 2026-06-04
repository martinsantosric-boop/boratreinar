enum AchievementType {
  firstRun,
  streak3,
  streak7,
  streak30,
  distance5k,
  distance10k,
  distance21k,
  distance42k,
  totalRuns10,
  totalRuns50,
  totalRuns100,
  speedRunner, // Pace < 5 min/km
  marathon, // 42km em uma corrida
  centurion, // 100km total
  consistency, // 4 semanas seguidas batendo meta
}

class Achievement {
  const Achievement({
    required this.type,
    required this.isUnlocked,
    this.unlockedAt,
  });

  final AchievementType type;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  String get title {
    switch (type) {
      case AchievementType.firstRun:
        return 'Primeira Corrida';
      case AchievementType.streak3:
        return 'Aquecendo';
      case AchievementType.streak7:
        return 'Uma Semana';
      case AchievementType.streak30:
        return 'Hábito Formado';
      case AchievementType.distance5k:
        return '5K Master';
      case AchievementType.distance10k:
        return '10K Master';
      case AchievementType.distance21k:
        return 'Meia Maratona';
      case AchievementType.distance42k:
        return 'Maratonista';
      case AchievementType.totalRuns10:
        return 'Dedicado';
      case AchievementType.totalRuns50:
        return 'Veterano';
      case AchievementType.totalRuns100:
        return 'Lenda';
      case AchievementType.speedRunner:
        return 'Velocista';
      case AchievementType.marathon:
        return 'Distância Épica';
      case AchievementType.centurion:
        return 'Centurião';
      case AchievementType.consistency:
        return 'Consistência';
    }
  }

  String get description {
    switch (type) {
      case AchievementType.firstRun:
        return 'Complete sua primeira corrida';
      case AchievementType.streak3:
        return 'Treine por 3 dias seguidos';
      case AchievementType.streak7:
        return 'Treine por 7 dias seguidos';
      case AchievementType.streak30:
        return 'Treine por 30 dias seguidos';
      case AchievementType.distance5k:
        return 'Corra 5km em uma única corrida';
      case AchievementType.distance10k:
        return 'Corra 10km em uma única corrida';
      case AchievementType.distance21k:
        return 'Complete uma meia maratona';
      case AchievementType.distance42k:
        return 'Complete uma maratona completa';
      case AchievementType.totalRuns10:
        return 'Complete 10 corridas';
      case AchievementType.totalRuns50:
        return 'Complete 50 corridas';
      case AchievementType.totalRuns100:
        return 'Complete 100 corridas';
      case AchievementType.speedRunner:
        return 'Pace abaixo de 5:00 /km';
      case AchievementType.marathon:
        return 'Corra 42km em uma corrida';
      case AchievementType.centurion:
        return 'Acumule 100km no total';
      case AchievementType.consistency:
        return 'Bata sua meta por 4 semanas seguidas';
    }
  }

  String get icon {
    switch (type) {
      case AchievementType.firstRun:
        return '🎯';
      case AchievementType.streak3:
        return '🔥';
      case AchievementType.streak7:
        return '🔥🔥';
      case AchievementType.streak30:
        return '🔥🔥🔥';
      case AchievementType.distance5k:
        return '🏅';
      case AchievementType.distance10k:
        return '🏅🏅';
      case AchievementType.distance21k:
        return '🎖️';
      case AchievementType.distance42k:
        return '🏆';
      case AchievementType.totalRuns10:
        return '⭐';
      case AchievementType.totalRuns50:
        return '⭐⭐';
      case AchievementType.totalRuns100:
        return '⭐⭐⭐';
      case AchievementType.speedRunner:
        return '⚡';
      case AchievementType.marathon:
        return '👑';
      case AchievementType.centurion:
        return '💯';
      case AchievementType.consistency:
        return '📈';
    }
  }

  int get xpReward {
    switch (type) {
      case AchievementType.firstRun:
        return 50;
      case AchievementType.streak3:
        return 100;
      case AchievementType.streak7:
        return 200;
      case AchievementType.streak30:
        return 500;
      case AchievementType.distance5k:
        return 150;
      case AchievementType.distance10k:
        return 300;
      case AchievementType.distance21k:
        return 600;
      case AchievementType.distance42k:
        return 1000;
      case AchievementType.totalRuns10:
        return 200;
      case AchievementType.totalRuns50:
        return 500;
      case AchievementType.totalRuns100:
        return 1000;
      case AchievementType.speedRunner:
        return 250;
      case AchievementType.marathon:
        return 1000;
      case AchievementType.centurion:
        return 400;
      case AchievementType.consistency:
        return 800;
    }
  }

  Achievement copyWith({bool? isUnlocked, DateTime? unlockedAt}) {
    return Achievement(
      type: type,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      type: AchievementType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }
}
