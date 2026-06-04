class GeoSample {
  const GeoSample({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
    required this.accuracy,
  });

  final double latitude;
  final double longitude;
  final DateTime recordedAt;
  final double accuracy;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'recordedAt': recordedAt.toIso8601String(),
      'accuracy': accuracy,
    };
  }

  factory GeoSample.fromJson(Map<String, dynamic> json) {
    return GeoSample(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }
}
