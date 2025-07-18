import 'package:ps_app_clone_mvvm/core/use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/trophy_summary.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class GetTrophySummaryUseCase implements UseCase<Result<TrophySummary>, void> {
  final ProfileRepository _profileRepository;

  GetTrophySummaryUseCase({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Result<TrophySummary>> call({void params}) async {
    return await _profileRepository.getTrophySummary();
  }
}