import 'package:go_router/go_router.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_trophy_summary_use_case.dart';
import 'package:ps_app_clone_mvvm/routing/routes.dart';
import 'package:ps_app_clone_mvvm/ui/profile/view_models/profile_viewmodel.dart';
import 'package:ps_app_clone_mvvm/ui/profile/views/profile_screen.dart';

import 'package:ps_app_clone_mvvm/core/injection.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.profile,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: Routes.profile,
      builder: (context, state) {
        return ProfileScreen(
          viewModel: ProfileViewModel(
            getProfileUseCase: getIt<GetProfileUseCase>(),
            getTrophySummaryUseCase: getIt<GetTrophySummaryUseCase>(),
          ),
        );
      },
    ),
  ],
);
