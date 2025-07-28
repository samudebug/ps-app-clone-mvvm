import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_trophy_groups_use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy_group.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class MockGamesRepository extends Mock implements GamesRepository {}

void main() {
  late MockGamesRepository mockGamesRepository;
  late GetTrophyGroupsUseCase useCase;

  setUp(() {
    mockGamesRepository = MockGamesRepository();
    useCase = GetTrophyGroupsUseCase(gamesRepository: mockGamesRepository);
  });

  group('GetTrophyGroupsUseCase', () {
    const gameId = 'game_123';
    final params = GetTrophyGroupsParams(gameId);
    final trophyGroups = [
      TrophyGroup(id: '1', name: 'Group 1', iconUrl: '', detail: '', trophyCountInfo: []),
      TrophyGroup(id: '2', name: 'Group 2', iconUrl: '', detail: '', trophyCountInfo: []),
    ];

    test('returns Result.ok when repository returns trophy groups', () async {
      when(() => mockGamesRepository.getTrophyGroups(gameId))
          .thenAnswer((_) async => Result.ok(trophyGroups));

      final result = await useCase(params: params);

      expect(result, isA<Result<List<TrophyGroup>>>());
      expect(result, isA<Ok<List<TrophyGroup>>>());
      expect((result as Ok<List<TrophyGroup>>).value, trophyGroups);
      verify(() => mockGamesRepository.getTrophyGroups(gameId)).called(1);
    });

    test('returns Result.error when params is null', () async {
      final result = await useCase(params: null);

      expect(result, isA<Result<List<TrophyGroup>>>());
      expect(result, isA<Error<List<TrophyGroup>>>());
      expect((result as Error<List<TrophyGroup>>).error, isA<Exception>());
      verifyNever(() => mockGamesRepository.getTrophyGroups(any()));
    });

    test('returns Result.error when repository returns error', () async {
      when(() => mockGamesRepository.getTrophyGroups(gameId))
          .thenAnswer((_) async => Result.error(Exception("Repository error")));

      final result = await useCase(params: params);

      expect(result, isA<Result<List<TrophyGroup>>>());
      expect(result, isA<Error<List<TrophyGroup>>>());
      expect((result as Error<List<TrophyGroup>>).error, isA<Exception>());
      verify(() => mockGamesRepository.getTrophyGroups(gameId)).called(1);
    });
  });
}