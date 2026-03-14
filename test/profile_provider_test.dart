import 'package:flutter_test/flutter_test.dart';
import 'package:masar/models/user_profile.dart';
import 'package:masar/providers/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProfileProvider Tests', () {
    test('Initial profile should be null', () {
      final provider = ProfileProvider();
      expect(provider.profile, isNull);
    });

    test('Saving and loading profile works', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProfileProvider();

      final profile = UserProfile(
        name: 'Test User',
        academicYear: '1',
        college: 'Engineering',
        department: 'CS',
        semester: '1',
      );

      await provider.saveProfile(profile);
      expect(provider.profile?.name, 'Test User');

      final newProvider = ProfileProvider();
      await newProvider.loadProfile();
      expect(newProvider.profile?.name, 'Test User');
    });

    test('Score update works', () async {
      SharedPreferences.setMockInitialValues({
        'user_name': 'Test',
        'user_score': 10,
      });
      final provider = ProfileProvider();
      await provider.loadProfile();

      await provider.updateScore(5);
      expect(provider.profile?.score, 15);

      await provider.updateScore(-20);
      expect(provider.profile?.score, 0); // Should not go below 0
    });
  });
}
