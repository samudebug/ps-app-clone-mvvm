import 'package:flutter/material.dart';
import 'package:ps_app_clone_mvvm/core/injection.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/games/get_games_use_case.dart';
import 'package:ps_app_clone_mvvm/domain/use_cases/profile/get_profile_use_case.dart';
import 'package:ps_app_clone_mvvm/routing/routes.dart';
import 'package:ps_app_clone_mvvm/ui/core/ui/error_indicator.dart';
import 'package:ps_app_clone_mvvm/ui/games/view_models/games_view_model.dart';
import 'package:ps_app_clone_mvvm/ui/games/views/game_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late GamesViewModel viewModel;
  
  @override
  void initState() {
    super.initState();
    viewModel = GamesViewModel(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      getGamesUseCase: getIt<GetGamesUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ListenableBuilder(
              listenable: viewModel.getProfileCommand,
              builder: (context, child) {
                if (viewModel.getProfileCommand.running) {
                  return SliverSkeletonizer(
                    child: SliverAppBar(
                      title: Row(
                        spacing: 8,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: ClipOval(
                              child: Image.network(
                                'http://static-resource.np.community.playstation.net/avatar/WWS_A/A2002_l.png',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                          Text(
                            'Samuel Martins',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (viewModel.getProfileCommand.error) {
                  return SliverAppBar(
                    title: Text(
                      'Error loading profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }
                return SliverAppBar(
                  title: GestureDetector(
                    onTap: () => context.push(
                      Routes.profile,
                      extra: viewModel.profile,
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: ClipOval(
                            child: Image.network(
                              viewModel.profile?.avatarUrl ??
                                  'http://static-resource.np.community.playstation.net/avatar/WWS_A/A2002_l.png',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        Text(
                          viewModel.profile?.fullName ??
                              'Samuel Martins',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SliverAppBar(
              elevation: 8,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              title: Text(
                'Games',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              floating: true,
              snap: true,
              pinned: true,
            ),
            ListenableBuilder(
              listenable: viewModel.getGamesCommand,
              builder: (context, child) {
                if (viewModel.getGamesCommand.running) {
                  return SliverSkeletonizer(
                    child: SliverList.list(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GameListItem(
                            game: Game(
                              id: 'loading_$index',
                              name: 'Loading...',
                              imageUrl:
                                  'https://image.api.playstation.com/vulcan/ap/rnd/202503/2016/b69c06fb108299866057126b0d3a0530bdf96a39d2ce1cb9.png',
                              duration: GameDuration(hours: 0, minutes: 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (viewModel.getGamesCommand.error) {
                  return ErrorIndicator(
                    title: 'Failed to load games',
                    label: 'Retry',
                    onPressed: () {
                      viewModel.getGamesCommand.execute();
                    },
                  );
                }
                return SliverList.builder(
                  itemCount: viewModel.games.length,
                  itemBuilder: (context, index) {
                    final game = viewModel.games[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => context.push(Routes.game_details(game.id), extra: game),
                        child: GameListItem(game: game),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
