import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_trophies_use_case.dart';
import 'package:ps_app_clone_mvvm/utils/command.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class TrophiesViewModel extends ChangeNotifier {
  TrophiesViewModel({
    required this.gameId,
    required this.trophyGroupId,
    required this.getTrophiesUseCase,
  }) {
    getTrophiesCommand = Command1<List<Trophy>, GetTrophiesParams>(
      getTrophies,
    )..execute(GetTrophiesParams(gameId: gameId, trophyGroupId: trophyGroupId));
  }

  final String gameId;
  final String trophyGroupId;
  final GetTrophiesUseCase getTrophiesUseCase;
  final Logger _log = Logger('TrophiesViewModel');

  List<Trophy> _trophies = [];
  List<Trophy> get trophies => _trophies;

  bool seeHiddenTrophies = false;

  late Command1<List<Trophy>, GetTrophiesParams> getTrophiesCommand;


  Future<Result<List<Trophy>>> getTrophies(
    GetTrophiesParams params,
  ) async {
    try {
      final result = await getTrophiesUseCase(params: params);
      switch (result) {
        case Ok<List<Trophy>> ok:
          _log.info('Trophies fetched successfully for game $gameId');
          _trophies = result.value;
          return ok;
        case Error<List<Trophy>> error:
          _log.severe(
            'Failed to fetch trophies for game $gameId: ${error.error}',
          );
          return error;
      }
    } finally {
      notifyListeners();
    }
  }

  bool toggleSeeHiddenTrophies() {
    seeHiddenTrophies = !seeHiddenTrophies;
    notifyListeners();
    return seeHiddenTrophies;
  }
}