import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository.dart';
import 'package:ps_app_clone_mvvm/data/services/api/api_service.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/trophy_summary.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

extension ProfileRemote on Profile {
  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      aboutMe: json['about_me'],
      username: json['username'],
      avatarUrl: (json['avatar_urls'] as List<dynamic>).isNotEmpty
          ? json['avatar_urls'][0]['avatar_url']
          : '',
    );
  }
}

extension TrophySummaryRemote on TrophySummary {
  static TrophySummary fromJson(Map<String, dynamic> json) {
    return TrophySummary(
      total: json['total'],
      bronze: json['bronze'],
      silver: json['silver'],
      gold: json['gold'],
      platinum: json['platinum'],
    );
  }
}

class ProfileRepositoryRemote implements ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryRemote({required this.apiClient});

  @override
  Future<Result<Profile>> getProfile() async {
    try {
      final data = await apiClient.get('/profile');
      final profile = ProfileRemote.fromJson(data);
      return Result.ok(profile);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<TrophySummary>> getTrophySummary() async {
    try {
      final data = await apiClient.get('/profile/trophies');
      final trophySummary = TrophySummaryRemote.fromJson(data);
      return Result.ok(trophySummary);
    } catch (e) {
      return Result.error(e);
    }
  }
}