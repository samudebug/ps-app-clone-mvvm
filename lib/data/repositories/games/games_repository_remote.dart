import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/data/services/api/api_service.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy_group.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

extension GameRemote on Game {
  static Game fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      duration: GameDuration(
        hours: json['duration']['hours'],
        minutes: json['duration']['minutes'],
      ),
    );
  }
}

extension TrophyGroupRemote on TrophyGroup {
  static TrophyGroup fromJson(Map<String, dynamic> json) {
    return TrophyGroup(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      iconUrl: json['icon_url'],
      trophyCountInfo: (json['trophy_count_info'] as Map<String, dynamic>)
          .entries
          .map((entry) => TrophyCountInfo(
                type: entry.key,
                total: entry.value['total'],
                earned: entry.value['earned'],
              ))
          .toList(),
    );
  }
}

class GamesRepositoryRemote implements GamesRepository {
  final ApiClient apiClient;
  GamesRepositoryRemote({required this.apiClient});
  @override
  Future<Result<List<Game>>> getGames() async {
    try {
      final response = await apiClient.get('/games');
      final games = (response as List)
          .map((gameJson) => GameRemote.fromJson(gameJson))
          .toList();
      return Result.ok(games);
      
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<TrophyGroup>>> getTrophyGroups(String gameId) async {
    try {
      final response = await apiClient.get('/games/$gameId/trophy_groups');
      final trophyGroups = (response as List)
          .map((groupJson) => TrophyGroupRemote.fromJson(groupJson))
          .toList();
      return Result.ok(trophyGroups);
    } catch (e) {
      return Result.error(e);
    }
  }
}
