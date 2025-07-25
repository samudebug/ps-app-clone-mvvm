import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

abstract class GamesRepository {
  Future<Result<List<Game>>> getGames();
}