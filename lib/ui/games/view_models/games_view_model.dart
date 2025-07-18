import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_games_use_case.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:ps_app_clone_mvvm/utils/command.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class GamesViewModel extends ChangeNotifier {
  GamesViewModel({required this.getProfileUseCase, required this.getGamesUseCase}) {
    // Initialize any commands or state here if needed
    getProfileCommand = Command0(getProfile)..execute();
    getGamesCommand = Command0(getGames)..execute();
  }

  final GetProfileUseCase getProfileUseCase;
  final GetGamesUseCase getGamesUseCase;
  final Logger _log = Logger('GamesViewModel');

  late Command0 getProfileCommand;
  late Command0 getGamesCommand;

  Profile? _profile;
  Profile? get profile => _profile;

  List<Game> _games = [];
  List<Game> get games => _games;

  Future<Result<Profile>> getProfile() async {
    try {
      // final result = Result.ok(
      //   Profile(
      //     id: '8499245957547228232',
      //     fullName: 'Samuel Martins',
      //     aboutMe: '',
      //     username: 'SamGunzBlazin',
      //     avatarUrl:
      //         'http://static-resource.np.community.playstation.net/avatar/WWS_A/A2002_l.png',
      //   ),
      // );
      final result = await getProfileUseCase();
      switch (result) {
        case Ok<Profile> ok:
          _profile = ok.value;
          _log.info('Profile fetched successfully: ${_profile?.fullName}');
        case Error<Profile> error:
          _log.severe('Failed to fetch profile: ${error.error}');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
  
  Future<Result<List<Game>>> getGames() async {
    try {
      // final result = Result.ok([
      //   Game(
      //     id: '1',
      //     name: 'Game 1',
      //     imageUrl: 'https://example.com/game1.png',
      //     duration: GameDuration(hours: 10, minutes: 30),
      //   ),
      //   Game(
      //     id: '2',
      //     name: 'Game 2',
      //     imageUrl: 'https://example.com/game2.png',
      //     duration: GameDuration(hours: 5, minutes: 15),
      //   ),
      // ]);
      final result = await getGamesUseCase();
      switch (result) {
        case Ok<List<Game>> ok:
          _games = ok.value;
          _log.info('Games fetched successfully: ${_games.length} games');
        case Error<List<Game>> error:
          _log.severe('Failed to fetch games: ${error.error}');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
