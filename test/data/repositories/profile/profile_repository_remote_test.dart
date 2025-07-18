import 'package:flutter_test/flutter_test.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository_remote.dart';
import 'package:ps_app_clone_mvvm/data/services/api/api_service.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/trophy_summary.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ProfileRepositoryRemote profileRepository;

  setUp(() {
    mockApiClient = MockApiClient();
    profileRepository = ProfileRepositoryRemote(apiClient: mockApiClient);
  });

  group('ProfileRepositoryRemote', () {
    test('getProfile returns a Profile on success', () async {
      // Arrange
      final jsonResponse = {
        'id': '1',
        'full_name': 'John Doe',
        'about_me': 'Software Developer',
        'username': 'johndoe',
        'avatar_urls': [
          {'avatar_url': 'https://example.com/avatar.jpg'}
        ]
      };
      when(() => mockApiClient.get('/profile')).thenAnswer((_) async => jsonResponse);

      // Act
      final result = await profileRepository.getProfile();

      // Assert
      expect(result, isA<Result<Profile>>());
      expect(result, isA<Ok<Profile>>());
      expect((result as Ok<Profile>).value, isA<Profile>());
      expect((result).value.fullName, 'John Doe');
    });

    test('getProfile returns an error on failure', () async {
      // Arrange
      when(() => mockApiClient.get('/profile')).thenThrow(Exception('Failed to fetch profile'));

      // Act
      final result = await profileRepository.getProfile();

      // Assert
      expect(result, isA<Result<Profile>>());
      expect(result, isA<Error<Profile>>());
      expect((result as Error<Profile>).error, isA<Exception>());
    });
  });
  test('getTrophySummary returns a TrophySummary on success', () async {
    // Arrange
    final jsonResponse = {
    'total': 100,
    'bronze': 50,
    'silver': 30,
    'gold': 15,
    'platinum': 5,
    };
    when(() => mockApiClient.get('/profile/trophies')).thenAnswer((_) async => jsonResponse);

    // Act
    final result = await profileRepository.getTrophySummary();
    

    // Assert
    expect(result, isA<Result>());
    expect(result, isA<Ok>());
    expect((result as Ok).value, isA<TrophySummary>());
    expect((result as Ok<TrophySummary>).value.total, 100);
    expect(result.value.bronze, 50);
    expect(result.value.silver, 30);
    expect(result.value.gold, 15);
    expect(result.value.platinum, 5);
  });

  test('getTrophySummary returns an error on failure', () async {
    // Arrange
    when(() => mockApiClient.get('/profile/trophies')).thenThrow(Exception('Failed to fetch trophies'));

    // Act
    final result = await profileRepository.getTrophySummary();

    // Assert
    expect(result, isA<Result>());
    expect(result, isA<Error>());
    expect((result as Error).error, isA<Exception>());
  });
}