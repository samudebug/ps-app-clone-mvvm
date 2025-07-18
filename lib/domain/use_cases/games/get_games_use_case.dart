import 'package:ps_app_clone_mvvm/core/use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class GetGamesUseCase implements UseCase<Result<List<Game>>, void> {
  final GamesRepository gamesRepository;

  GetGamesUseCase({required this.gamesRepository});

  @override
  Future<Result<List<Game>>> call({void params}) async {
    return await gamesRepository.getGames();
  }

}