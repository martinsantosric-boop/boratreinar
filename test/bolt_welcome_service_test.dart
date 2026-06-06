import 'package:cooper_maratonista/services/bolt_welcome_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('welcome video is shown only once per user', () async {
    SharedPreferences.setMockInitialValues({});
    final service = BoltWelcomeService();

    expect(await service.shouldShowForUser('user-a'), isTrue);

    await service.markSeenForUser('user-a');

    expect(await service.shouldShowForUser('user-a'), isFalse);
    expect(await service.shouldShowForUser('user-b'), isTrue);
  });

  test('welcome video is skipped when there is no user id', () async {
    SharedPreferences.setMockInitialValues({});
    final service = BoltWelcomeService();

    expect(await service.shouldShowForUser(null), isFalse);
    expect(await service.shouldShowForUser(''), isFalse);
  });
}
