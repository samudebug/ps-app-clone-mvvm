import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ps_app_clone_mvvm/core/environment.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository_remote.dart';
import 'package:ps_app_clone_mvvm/data/services/api/api_service.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_trophy_summary_use_case.dart';

final GetIt getIt = GetIt.instance;
final Dio dio = Dio(BaseOptions(
  baseUrl: API_URL,
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
));
void setupServices() {
  getIt.registerSingleton<ApiClient>(ApiClient(dio: dio));
}

void setupRepositories() {
  getIt.registerCachedFactory(() =>  ProfileRepositoryRemote(apiClient: getIt<ApiClient>()));
}
void setupUseCases() {
  getIt.registerSingleton(GetProfileUseCase(profileRepository: getIt<ProfileRepositoryRemote>()));
  getIt.registerSingleton(GetTrophySummaryUseCase(profileRepository: getIt<ProfileRepositoryRemote>()));
}

void setupInjection() {
  setupServices();
  setupRepositories();
  setupUseCases();
}