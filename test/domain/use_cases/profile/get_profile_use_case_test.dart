import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

// Mock class for ProfileRepository
class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockProfileRepository;
  late GetProfileUseCase getProfileUseCase;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    getProfileUseCase = GetProfileUseCase(
      profileRepository: mockProfileRepository,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      Profile(
        id: '1',
        fullName: 'Test User',
        aboutMe: 'About Test User',
        username: 'testuser',
        avatarUrl: 'https://example.com/avatar.png',
      ),
    );
  });

  test(
    'should return Result<Profile> when repository returns profile',
    () async {
      final profile = Profile(
        id: '1',
        fullName: 'Test User',
        aboutMe: 'About Test User',
        username: 'testuser',
        avatarUrl: 'https://example.com/avatar.png',
      );
      final expectedResult = Result.ok(profile);

      when(
        () => mockProfileRepository.getProfile(),
      ).thenAnswer((_) async => expectedResult);

      final result = await getProfileUseCase();

      expect(result, expectedResult);
      verify(() => mockProfileRepository.getProfile()).called(1);
    },
  );

  test('should return Result.error when repository returns error', () async {
    final expectedResult = Result<Profile>.error('Failed to fetch profile');

    when(
      () => mockProfileRepository.getProfile(),
    ).thenAnswer((_) async => expectedResult);

    final result = await getProfileUseCase();

    expect(result, expectedResult);
    verify(() => mockProfileRepository.getProfile()).called(1);
  });

  test('should call repository getProfile with no params', () async {
    when(() => mockProfileRepository.getProfile()).thenAnswer(
      (_) async => Result.ok(
        Profile(
          id: '1',
          fullName: 'Test User',
          aboutMe: 'About Test User',
          username: 'testuser',
          avatarUrl: 'https://example.com/avatar.png',
        ),
      ),
    );

    await getProfileUseCase();

    verify(() => mockProfileRepository.getProfile()).called(1);
  });
}
