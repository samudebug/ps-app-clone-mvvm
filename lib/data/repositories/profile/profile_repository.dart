import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/trophy_summary.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

abstract class ProfileRepository {
  Future<Result<Profile>> getProfile();
  Future<Result<TrophySummary>> getTrophySummary();
}