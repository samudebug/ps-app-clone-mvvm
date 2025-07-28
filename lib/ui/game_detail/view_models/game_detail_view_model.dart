import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy_group.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_trophy_groups_use_case.dart';
import 'package:ps_app_clone_mvvm/utils/command.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class GameDetailViewModel extends ChangeNotifier {
  GameDetailViewModel({
    required this.gameId,
    required this.getTrophyGroupsUseCase,
  }) {
    getTrophyGroupsCommand = Command1<List<TrophyGroup>, GetTrophyGroupsParams>(
      getTrophyGroups,
    )..execute(GetTrophyGroupsParams(gameId));
  }

  final String gameId;
  final GetTrophyGroupsUseCase getTrophyGroupsUseCase;
  final Logger _log = Logger('GameDetailViewModel');

  List<TrophyGroup> _trophyGroups = [];
  List<TrophyGroup> get trophyGroups => _trophyGroups;

  late Command1<List<TrophyGroup>, GetTrophyGroupsParams>
  getTrophyGroupsCommand;

  Future<Result<List<TrophyGroup>>> getTrophyGroups(
    GetTrophyGroupsParams params,
  ) async {
    try {
      final result = await getTrophyGroupsUseCase(params: params);
      switch (result) {
        case Ok<List<TrophyGroup>> ok:
          _log.info('Trophy groups fetched successfully for game $gameId');
          _trophyGroups = result.value;
          return ok;
        case Error<List<TrophyGroup>> error:
          _log.severe(
            'Failed to fetch trophy groups for game $gameId: ${error.error}',
          );
          return error;
      }
    } finally {
      notifyListeners();
    }
  }
}
