import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ps_app_clone_mvvm/core/environment.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository.dart';
import 'package:ps_app_clone_mvvm/data/repositories/games/games_repository_remote.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository.dart';
import 'package:ps_app_clone_mvvm/data/repositories/profile/profile_repository_remote.dart';
import 'package:ps_app_clone_mvvm/data/services/api/api_service.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_games_use_case.dart';
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
  getIt.registerCachedFactory<ProfileRepository>(() =>  ProfileRepositoryRemote(apiClient: getIt<ApiClient>()));
  getIt.registerCachedFactory<GamesRepository>(() => GamesRepositoryRemote(apiClient: getIt<ApiClient>()));
}
void setupUseCases() {
  getIt.registerSingleton(GetProfileUseCase(profileRepository: getIt<ProfileRepository>()));
  getIt.registerSingleton(GetTrophySummaryUseCase(profileRepository: getIt<ProfileRepository>()));
  getIt.registerSingleton(GetGamesUseCase(gamesRepository: getIt<GamesRepository>()));
}

void setupInjection() {
  setupServices();
  setupRepositories();
  setupUseCases();
}