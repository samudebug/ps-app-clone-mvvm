import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository_remote.dart';
import 'package:ps_app_clone_mvvm/data/services/api/api_service.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy_group.dart';
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

  group('getTrophyGroups', () {
    final mockTrophyGroupsJson = [
      {
        'id': 'tg1',
        'name': 'Base Game',
        'detail': 'Main trophy group',
        'icon_url': 'http://example.com/trophy.png',
        'trophy_count_info': {
          'platinum': {'total': 1, 'earned': 1},
          'gold': {'total': 2, 'earned': 1},
        },
      }
    ];

    final mockTrophyGroups = [
      TrophyGroup(
        id: 'tg1',
        name: 'Base Game',
        detail: 'Main trophy group',
        iconUrl: 'http://example.com/trophy.png',
        trophyCountInfo: [
          TrophyCountInfo(type: 'platinum', total: 1, earned: 1),
          TrophyCountInfo(type: 'gold', total: 2, earned: 1),
        ],
      ),
    ];

    test('returns list of trophy groups on success', () async {
      when(() => mockApiClient.get('/games/1/trophy_groups'))
          .thenAnswer((_) async => mockTrophyGroupsJson);

      final result = await repository.getTrophyGroups('1');

      expect(result, isA<Result<List<TrophyGroup>>>());
      expect(result, isA<Ok<List<TrophyGroup>>>());
      expect((result as Ok<List<TrophyGroup>>).value, mockTrophyGroups);
    });

    test('returns error result on exception', () async {
      when(() => mockApiClient.get('/games/1/trophy_groups'))
          .thenThrow(Exception('API error'));

      final result = await repository.getTrophyGroups('1');

      expect(result, isA<Result<List<TrophyGroup>>>());
      expect(result, isA<Error<List<TrophyGroup>>>());
      expect((result as Error<List<TrophyGroup>>).error, isA<Exception>());
    });

    test('TrophyGroupRemote.fromJson parses correctly', () {
      final group = TrophyGroupRemote.fromJson(mockTrophyGroupsJson[0]);

      expect(group.id, mockTrophyGroups[0].id);
      expect(group.name, mockTrophyGroups[0].name);
      expect(group.detail, mockTrophyGroups[0].detail);
      expect(group.iconUrl, mockTrophyGroups[0].iconUrl);
      expect(group.trophyCountInfo.length, 2);
      expect(group.trophyCountInfo[0].type, 'platinum');
      expect(group.trophyCountInfo[0].total, 1);
      expect(group.trophyCountInfo[0].earned, 1);
      expect(group.trophyCountInfo[1].type, 'gold');
      expect(group.trophyCountInfo[1].total, 2);
      expect(group.trophyCountInfo[1].earned, 1);
    });

    test('getTrophyGroups returns empty list if API returns empty list', () async {
      when(() => mockApiClient.get('/games/1/trophy_groups'))
          .thenAnswer((_) async => []);

      final result = await repository.getTrophyGroups('1');

      expect(result, isA<Ok<List<TrophyGroup>>>());
      expect((result as Ok<List<TrophyGroup>>).value, isEmpty);
    });
  });
}