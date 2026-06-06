import 'package:intl/intl.dart';

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  return '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}

String formatDistance(double meters) {
  return '${(meters / 1000).toStringAsFixed(2)} km';
}

String formatPace(int secondsPerKm) {
  if (secondsPerKm <= 0) return '--';
  final minutes = secondsPerKm ~/ 60;
  final seconds = secondsPerKm % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
}

String formatSpeed(double speedKmh) {
  if (speedKmh <= 0) return '--';
  return '${speedKmh.toStringAsFixed(1)} km/h';
}

String formatElevationGain(double meters) {
  if (meters <= 0) return '--';
  return '${meters.round()} m';
}

String formatCadence(int stepsPerMinute) {
  if (stepsPerMinute <= 0) return '--';
  return '$stepsPerMinute spm';
}

String formatHeartRate(int? beatsPerMinute) {
  if (beatsPerMinute == null || beatsPerMinute <= 0) return '--';
  return '$beatsPerMinute bpm';
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}

DateTime startOfWeek(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  return normalized.subtract(Duration(days: normalized.weekday - 1));
}
