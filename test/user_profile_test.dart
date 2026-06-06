import 'package:cooper_maratonista/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('profile maps Supabase snake case fields', () {
    final profile = UserProfile.fromSupabase({
      'full_name': 'Ana Corredora',
      'gender': 'feminino',
      'body_weight_kg': 62.5,
      'height_cm': 168,
      'age': 31,
    });

    expect(profile.displayName, 'Ana Corredora');
    expect(profile.gender, 'feminino');
    expect(profile.bodyWeightKg, 62.5);
    expect(profile.heightCm, 168);
    expect(profile.age, 31);
    expect(profile.hasAnyData, isTrue);
  });

  test('empty profile reports no user data', () {
    expect(const UserProfile().hasAnyData, isFalse);
  });
}
