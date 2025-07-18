import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_games_use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class MockGamesRepository extends Mock implements GamesRepository {}

void main() {
  late MockGamesRepository mockGamesRepository;
  late GetGamesUseCase getGamesUseCase;

  setUp(() {
    mockGamesRepository = MockGamesRepository();
    getGamesUseCase = GetGamesUseCase(gamesRepository: mockGamesRepository);
  });
  setUpAll(() {
    registerFallbackValue(
      Game(
        id: '1',
        name: 'Test Game',
        imageUrl: 'https://example.com/game.png',
        duration: GameDuration(hours: 1, minutes: 30),
      ),
    );
  });
  group('GetGamesUseCase', () {
    test('should return Result.ok with list of games when repository returns games', () async {
      final games = [Game(id: '1', name: 'Game 1', imageUrl: '', duration: GameDuration(hours: 1, minutes: 30)), Game(id: '2', name: 'Game 2', imageUrl: '', duration: GameDuration(hours: 1, minutes: 30))];
      final result = Result.ok(games);

      when(() => mockGamesRepository.getGames()).thenAnswer((_) async => result);

      final response = await getGamesUseCase();

      expect(response, isA<Result<List<Game>>>());
      expect(response, isA<Ok<List<Game>>>());
      expect((response as Ok<List<Game>>).value, games);
      verify(() => mockGamesRepository.getGames()).called(1);
    });

    test('should return Result.error when repository returns failure', () async {
      final error = Exception('Failed to fetch games');
      final result = Result<List<Game>>.error(error);

      when(() => mockGamesRepository.getGames()).thenAnswer((_) async => result);

      final response = await getGamesUseCase();

      expect(response, isA<Result<List<Game>>>());
      expect(response, isA<Error<List<Game>>>());
      expect((response as Error<List<Game>>).error, error);
      verify(() => mockGamesRepository.getGames()).called(1);
    });
  });
}