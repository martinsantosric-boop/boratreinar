class UserProfile {
  const UserProfile({
    this.displayName = '',
    this.gender = '',
    this.bodyWeightKg = 0,
    this.heightCm = 0,
    this.age = 0,
  });

  final String displayName;
  final String gender;
  final double bodyWeightKg;
  final double heightCm;
  final int age;

  double get strideLengthMeters => heightCm * 0.00414;

  int estimateSteps(double distanceMeters) {
    if (distanceMeters <= 0 || strideLengthMeters <= 0) return 0;
    return (distanceMeters / strideLengthMeters).round();
  }

  int get stepsPerKm => estimateSteps(1000);

  UserProfile copyWith({
    String? displayName,
    String? gender,
    double? bodyWeightKg,
    double? heightCm,
    int? age,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      bodyWeightKg: bodyWeightKg ?? this.bodyWeightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'gender': gender,
      'bodyWeightKg': bodyWeightKg,
      'heightCm': heightCm,
      'age': age,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      displayName: (json['displayName'] as String?)?.trim() ?? '',
      gender: (json['gender'] as String?)?.trim() ?? '',
      bodyWeightKg: ((json['bodyWeightKg'] as num?) ?? 0).toDouble(),
      heightCm: ((json['heightCm'] as num?) ?? 0).toDouble(),
      age: ((json['age'] as num?) ?? 0).toInt(),
    );
  }
}
