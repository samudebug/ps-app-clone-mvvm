import 'package:ps_app_clone_mvvm/core/use_case.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/utils/result.dart';

class GetProfileUseCase implements UseCase<Result<Profile>, void> {
  final ProfileRepository profileRepository;

  GetProfileUseCase({required this.profileRepository});

  @override
  Future<Result<Profile>> call({void params}) {
    return profileRepository.getProfile();
  }
}