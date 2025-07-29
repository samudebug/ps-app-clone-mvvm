import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy_group.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/profile.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_trophies_use_case.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_trophy_summary_use_case.dart';
import 'package:ps_app_clone_mvvm/routing/routes.dart';
import 'package:ps_app_clone_mvvm/ui/game_detail/views/game_detail_page.dart';
import 'package:ps_app_clone_mvvm/ui/games/views/games_page.dart';
import 'package:ps_app_clone_mvvm/ui/profile/view_models/profile_viewmodel.dart';
import 'package:ps_app_clone_mvvm/ui/profile/views/profile_screen.dart';

import 'package:ps_app_clone_mvvm/core/injection.dart';
import 'package:ps_app_clone_mvvm/ui/trophies/view_models/trophies_view_model.dart';
import 'package:ps_app_clone_mvvm/ui/trophies/views/trophies_screen.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.games,
  debugLogDiagnostics: true,

  routes: [
    GoRoute(
      path: Routes.profile,

      pageBuilder: (context, state) {
        final Profile? profile = state.extra as Profile?;
        return CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: ProfileScreen(
            viewModel: ProfileViewModel(
              profile: profile,
              getProfileUseCase: getIt<GetProfileUseCase>(),
              getTrophySummaryUseCase: getIt<GetTrophySummaryUseCase>(),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.games,
      builder: (context, state) {
        return GamesPage(

        );
      },
      routes: [
        GoRoute(
          path: ':id',
          pageBuilder: (context, state) {
            final gameId = state.pathParameters['id']!;
            final Game game = state.extra as Game;
            return CustomTransitionPage(
              key: state.pageKey,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
              child: GameDetailPage(
                game: game,
                gameId: gameId,
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'trophies/:trophyGroupId',
              pageBuilder: (context, state) {
                final gameId = state.pathParameters['id']!;
                final trophyGroupId = state.pathParameters['trophyGroupId']!;
                final trophyGroup = state.extra as TrophyGroup;
                return CustomTransitionPage(
                  key: state.pageKey,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                  child: TrophiesScreen(
                    trophyGroup: trophyGroup,
                    viewModel: TrophiesViewModel(
                      gameId: gameId,
                      trophyGroupId: trophyGroupId,
                      getTrophiesUseCase: getIt<GetTrophiesUseCase>(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
