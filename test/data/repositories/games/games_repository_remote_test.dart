import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository_remote.dart';
import 'package:ps_app_clone_mvvm/data/services/api/api_service.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late GamesRepositoryRemote repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = GamesRepositoryRemote(apiClient: mockApiClient);
  });

  group('GamesRepositoryRemote', () {
    final mockGameJson = [{
      'id': '1',
      'name': 'Test Game',
      'image_url': 'http://example.com/image.png',
      'duration': {'hours': 2, 'minutes': 30},
    }];

    final mockGame = Game(
      id: '1',
      name: 'Test Game',
      imageUrl: 'http://example.com/image.png',
      duration: GameDuration(hours: 2, minutes: 30),
    );

    test('returns list of games on success', () async {
      when(() => mockApiClient.get('/games'))
          .thenAnswer((_) async => mockGameJson);

      final result = await repository.getGames();

      expect(result, isA<Result<List<Game>>>());
      expect(result, isA<Ok<List<Game>>>());
      expect((result as Ok<List<Game>>).value, [mockGame]);
    });

    test('returns error result on exception', () async {
      when(() => mockApiClient.get('/games')).thenThrow(Exception('API error'));

      final result = await repository.getGames();

      expect(result, isA<Result<List<Game>>>());
      expect(result, isA<Error<List<Game>>>());
      expect((result as Error<List<Game>>).error, isA<Exception>());
    });

    test('GameRemote.fromJson parses correctly', () {
      final game = GameRemote.fromJson(mockGameJson[0]);

      expect(game.id, mockGame.id);
      expect(game.name, mockGame.name);
      expect(game.imageUrl, mockGame.imageUrl);
      expect(game.duration.hours, mockGame.duration.hours);
      expect(game.duration.minutes, mockGame.duration.minutes);
    });

    test('getGames returns empty list if API returns empty list', () async {
      when(() => mockApiClient.get('/games')).thenAnswer((_) async => []);

      final result = await repository.getGames();

      expect(result, isA<Ok<List<Game>>>());
      expect((result as Ok<List<Game>>).value, isEmpty);
    });
  });
}