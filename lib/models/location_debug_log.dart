class LocationDebugLog {
  const LocationDebugLog({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
    required this.accuracy,
    required this.instantSpeedMetersPerSecond,
    required this.deltaMeters,
    required this.accumulatedDistanceMeters,
    required this.accepted,
    required this.message,
  });

  final double latitude;
  final double longitude;
  final DateTime recordedAt;
  final double accuracy;
  final double instantSpeedMetersPerSecond;
  final double deltaMeters;
  final double accumulatedDistanceMeters;
  final bool accepted;
  final String message;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'recordedAt': recordedAt.toIso8601String(),
      'accuracy': accuracy,
      'instantSpeedMetersPerSecond': instantSpeedMetersPerSecond,
      'deltaMeters': deltaMeters,
      'accumulatedDistanceMeters': accumulatedDistanceMeters,
      'accepted': accepted,
      'message': message,
    };
  }

  factory LocationDebugLog.fromJson(Map<String, dynamic> json) {
    return LocationDebugLog(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      accuracy: (json['accuracy'] as num).toDouble(),
      instantSpeedMetersPerSecond:
          ((json['instantSpeedMetersPerSecond'] as num?) ?? 0).toDouble(),
      deltaMeters: ((json['deltaMeters'] as num?) ?? 0).toDouble(),
      accumulatedDistanceMeters:
          ((json['accumulatedDistanceMeters'] as num?) ?? 0).toDouble(),
      accepted: (json['accepted'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
    );
  }
}
