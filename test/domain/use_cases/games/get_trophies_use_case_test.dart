import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_trophies_use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class MockGamesRepository extends Mock implements GamesRepository {}

void main() {
  late MockGamesRepository mockGamesRepository;
  late GetTrophiesUseCase useCase;

  setUp(() {
    mockGamesRepository = MockGamesRepository();
    useCase = GetTrophiesUseCase(gamesRepository: mockGamesRepository);
  });

  group('GetTrophiesUseCase', () {
    final params = GetTrophiesParams(gameId: 'game1', trophyGroupId: 'group1');
    final trophies = [
      Trophy(
        id: '1',
        name: 'Trophy 1',
        detail: 'desc',
        iconUrl: '',
        isHidden: false,
        type: TrophyType.gold,
        isEarned: false,
      ),
      Trophy(
        id: '2',
        name: 'Trophy 2',
        detail: 'desc',
        type: TrophyType.silver,
        iconUrl: '',
        isHidden: false,
        isEarned: true,
      ),
    ];

    test('returns trophies when repository returns success', () async {
      when(
        () => mockGamesRepository.getTrophies('game1', 'group1'),
      ).thenAnswer((_) async => Result.ok(trophies));

      final result = await useCase(params: params);

      expect(result, isA<Result<List<Trophy>>>());
      expect(result, isA<Ok<List<Trophy>>>());
      expect((result as Ok<List<Trophy>>).value, trophies);
      verify(
        () => mockGamesRepository.getTrophies('game1', 'group1'),
      ).called(1);
    });

    test('returns error when repository returns error', () async {
      final exception = Exception('Failed to fetch trophies');
      when(
        () => mockGamesRepository.getTrophies('game1', 'group1'),
      ).thenAnswer((_) async => Result.error(exception));

      final result = await useCase(params: params);

      expect(result, isA<Result<List<Trophy>>>());
      expect(result, isA<Error<List<Trophy>>>());
      expect((result as Error<List<Trophy>>).error, exception);
      verify(
        () => mockGamesRepository.getTrophies('game1', 'group1'),
      ).called(1);
    });

    test('returns error when params is null', () async {
      final result = await useCase(params: null);

      expect(result, isA<Result<List<Trophy>>>());
      expect(result, isA<Error<List<Trophy>>>());
      expect((result as Error<List<Trophy>>).error, isA<Exception>());
      verifyNever(() => mockGamesRepository.getTrophies(any(), any()));
    });
  });
}
