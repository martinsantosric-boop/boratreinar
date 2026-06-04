enum MissionType {
  runAnyDistance,
  run3km,
  run5km,
  runFor20Minutes,
  runFor30Minutes,
  maintainPace,
  takeSteps5k,
  takeSteps10k,
}

class DailyMission {
  const DailyMission({
    required this.type,
    required this.isCompleted,
    required this.date,
  });

  final MissionType type;
  final bool isCompleted;
  final DateTime date;

  String get title {
    switch (type) {
      case MissionType.runAnyDistance:
        return 'Corra qualquer distância';
      case MissionType.run3km:
        return 'Corra pelo menos 3km';
      case MissionType.run5km:
        return 'Corra pelo menos 5km';
      case MissionType.runFor20Minutes:
        return 'Corra por 20 minutos';
      case MissionType.runFor30Minutes:
        return 'Corra por 30 minutos';
      case MissionType.maintainPace:
        return 'Mantenha pace < 6:00 /km';
      case MissionType.takeSteps5k:
        return 'Dê 5.000 passos';
      case MissionType.takeSteps10k:
        return 'Dê 10.000 passos';
    }
  }

  String get icon {
    switch (type) {
      case MissionType.runAnyDistance:
        return '🎯';
      case MissionType.run3km:
        return '🏃';
      case MissionType.run5km:
        return '🏃‍♂️';
      case MissionType.runFor20Minutes:
        return '⏱️';
      case MissionType.runFor30Minutes:
        return '⏰';
      case MissionType.maintainPace:
        return '⚡';
      case MissionType.takeSteps5k:
        return '👣';
      case MissionType.takeSteps10k:
        return '🦶';
    }
  }

  int get xpReward {
    switch (type) {
      case MissionType.runAnyDistance:
        return 50;
      case MissionType.run3km:
        return 75;
      case MissionType.run5km:
        return 100;
      case MissionType.runFor20Minutes:
        return 60;
      case MissionType.runFor30Minutes:
        return 90;
      case MissionType.maintainPace:
        return 120;
      case MissionType.takeSteps5k:
        return 80;
      case MissionType.takeSteps10k:
        return 150;
    }
  }

  DailyMission copyWith({bool? isCompleted}) {
    return DailyMission(
      type: type,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
    };
  }

  factory DailyMission.fromJson(Map<String, dynamic> json) {
    return DailyMission(
      type: MissionType.values.firstWhere((e) => e.name == json['type']),
      isCompleted: json['isCompleted'] as bool,
      date: DateTime.parse(json['date'] as String),
    );
  }

  static List<DailyMission> generateForDate(DateTime date) {
    // Gera 3 missões diárias aleatórias
    final random = date.day + date.month * 31;
    final missions = <MissionType>[
      MissionType.runAnyDistance,
      MissionType.run3km,
      MissionType.run5km,
      MissionType.runFor20Minutes,
      MissionType.runFor30Minutes,
      MissionType.maintainPace,
      MissionType.takeSteps5k,
      MissionType.takeSteps10k,
    ];

    return {
      missions[(random) % missions.length],
      missions[(random + 3) % missions.length],
      missions[(random + 5) % missions.length],
    }
        .map((type) => DailyMission(type: type, isCompleted: false, date: date))
        .toList();
  }
}
