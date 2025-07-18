import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_trophy_summary_use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/trophy_summary.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockProfileRepository;
  late GetTrophySummaryUseCase useCase;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = GetTrophySummaryUseCase(profileRepository: mockProfileRepository);
  });

  group('GetTrophySummaryUseCase', () {
    final trophySummary = TrophySummary(
      platinum: 1,
      gold: 2,
      silver: 3,
      bronze: 4,
      total: 10,
    );

    test('returns Result.ok when repository returns success', () async {
      when(() => mockProfileRepository.getTrophySummary())
          .thenAnswer((_) async => Result.ok(trophySummary));

      final result = await useCase();

      expect(result, isA<Result<TrophySummary>>());
      expect(result, isA<Ok<TrophySummary>>());
      expect((result as Ok<TrophySummary>).value, trophySummary);
      verify(() => mockProfileRepository.getTrophySummary()).called(1);
    });

    test('returns Result.error when repository returns failure', () async {
      final error = Exception('Failed to fetch');
      when(() => mockProfileRepository.getTrophySummary())
          .thenAnswer((_) async => Result.error(error));

      final result = await useCase();

      expect(result, isA<Result<TrophySummary>>());
      expect(result, isA<Error<TrophySummary>>());
      expect((result as Error<TrophySummary>).error, error);
      verify(() => mockProfileRepository.getTrophySummary()).called(1);
    });

    test('calls repository exactly once', () async {
      when(() => mockProfileRepository.getTrophySummary())
          .thenAnswer((_) async => Result.ok(trophySummary));

      await useCase();

      verify(() => mockProfileRepository.getTrophySummary()).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    });
  });
}