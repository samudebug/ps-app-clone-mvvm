import 'package:ps_app_clone_mvvm/core/use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class GetTrophiesParams {
  final String gameId;
  final String trophyGroupId;

  GetTrophiesParams({
    required this.gameId,
    required this.trophyGroupId,
  });
}

class GetTrophiesUseCase implements UseCase<Result<List<Trophy>>, GetTrophiesParams> {
  final GamesRepository gamesRepository;

  GetTrophiesUseCase({required this.gamesRepository});

  @override
  Future<Result<List<Trophy>>> call({GetTrophiesParams? params}) async {
    if (params == null) {
      return Result.error(Exception("Invalid parameters"));
    }
    return await gamesRepository.getTrophies(
      params.gameId,
      params.trophyGroupId,
    );
  }
}