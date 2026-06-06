class GeoSample {
  const GeoSample({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
    required this.accuracy,
    this.altitudeMeters,
    this.speedMetersPerSecond,
  });

  final double latitude;
  final double longitude;
  final DateTime recordedAt;
  final double accuracy;
  final double? altitudeMeters;
  final double? speedMetersPerSecond;

  GeoSample copyWith({
    double? latitude,
    double? longitude,
    DateTime? recordedAt,
    double? accuracy,
    double? altitudeMeters,
    double? speedMetersPerSecond,
  }) {
    return GeoSample(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      recordedAt: recordedAt ?? this.recordedAt,
      accuracy: accuracy ?? this.accuracy,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      speedMetersPerSecond: speedMetersPerSecond ?? this.speedMetersPerSecond,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'recordedAt': recordedAt.toIso8601String(),
      'accuracy': accuracy,
      'altitudeMeters': altitudeMeters,
      'speedMetersPerSecond': speedMetersPerSecond,
    };
  }

  factory GeoSample.fromJson(Map<String, dynamic> json) {
    return GeoSample(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      accuracy: (json['accuracy'] as num).toDouble(),
      altitudeMeters: (json['altitudeMeters'] as num?)?.toDouble(),
      speedMetersPerSecond: (json['speedMetersPerSecond'] as num?)?.toDouble(),
    );
  }
}
