import 'package:ps_app_clone_mvvm/core/use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy_group.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class GetTrophyGroupsParams {
  final String gameId;

  GetTrophyGroupsParams(this.gameId);
}

class GetTrophyGroupsUseCase implements UseCase<Result<List<TrophyGroup>>, GetTrophyGroupsParams> {
  final GamesRepository gamesRepository;

  GetTrophyGroupsUseCase({required this.gamesRepository});

  @override
  Future<Result<List<TrophyGroup>>> call({GetTrophyGroupsParams? params}) async {
    if (params == null) {
      return Result.error(Exception("Invalid parameters"));
    }
    return await gamesRepository.getTrophyGroups(params.gameId);
  }
}