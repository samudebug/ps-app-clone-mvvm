import 'package:flutter/foundation.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/trophy_summary.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_trophy_summary_use_case.dart';
import 'package:ps_app_clone_mvvm/utils/command.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';
import 'package:logging/logging.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required this.getProfileUseCase, required this.getTrophySummaryUseCase, Profile? profile}) {
    if (profile != null) {
      _profile = profile;
    }
    getProfileCommand = Command0(_getProfile)..execute();
    getTrophySummaryCommand = Command0(getTrophySummary)..execute();
  }

  final GetProfileUseCase getProfileUseCase;
  final GetTrophySummaryUseCase getTrophySummaryUseCase;

  final Logger _log = Logger('ProfileViewModel');

  late Command0 getProfileCommand;
  late Command0 getTrophySummaryCommand;

  Profile? _profile;
  TrophySummary? _trophySummary;

  Profile? get profile => _profile;
  TrophySummary? get trophySummary => _trophySummary;

  Future<Result> _getProfile() async {
    try {
      if (_profile != null) {
        _log.info('Profile already loaded: ${_profile?.fullName}');
        return Result.ok(_profile!);
      }
      final result = await getProfileUseCase();
      // final result = Result.ok(Profile(
      //       id: '8499245957547228232',
      //       fullName: 'Samuel Martins',
      //       aboutMe: '',
      //       username: 'SamGunzBlazin',
      //       avatarUrl: 'http://static-resource.np.community.playstation.net/avatar/WWS_A/A2002_l.png',
      //     ));
      switch (result) {
        case Ok<Profile> ok:
          _profile = ok.value; 
          _log.info('Profile fetched successfully: ${profile?.fullName}');
        case Error<Profile> error:
          _log.severe('Failed to fetch profile: ${error.error}');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> getTrophySummary() async {
    try {
      final result = await getTrophySummaryUseCase();
      switch (result) {
        case Ok<TrophySummary> ok:
          _trophySummary = ok.value;
          _log.info('Trophy summary fetched successfully: ${_trophySummary?.total}');
        case Error<TrophySummary> error:
          _log.severe('Failed to fetch trophy summary: ${error.error}');
      }
      return result;
    } catch (e) {
      _log.severe('Error fetching trophy summary: $e');
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}
