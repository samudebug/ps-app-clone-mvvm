import 'package:flutter/material.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/routing/routes.dart';
import 'package:ps_app_clone_mvvm/ui/core/ui/error_indicator.dart';
import 'package:ps_app_clone_mvvm/ui/games/view_models/games_view_model.dart';
import 'package:ps_app_clone_mvvm/ui/games/views/game_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key, required this.viewModel});
  final GamesViewModel viewModel;

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ListenableBuilder(
              listenable: widget.viewModel.getProfileCommand,
              builder: (context, child) {
                if (widget.viewModel.getProfileCommand.running) {
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
                if (widget.viewModel.getProfileCommand.error) {
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
                      extra: widget.viewModel.profile,
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: ClipOval(
                            child: Image.network(
                              widget.viewModel.profile?.avatarUrl ??
                                  'http://static-resource.np.community.playstation.net/avatar/WWS_A/A2002_l.png',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        Text(
                          widget.viewModel.profile?.fullName ??
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
              listenable: widget.viewModel.getGamesCommand,
              builder: (context, child) {
                if (widget.viewModel.getGamesCommand.running) {
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
                if (widget.viewModel.getGamesCommand.error) {
                  return ErrorIndicator(
                    title: 'Failed to load games',
                    label: 'Retry',
                    onPressed: () {
                      widget.viewModel.getGamesCommand.execute();
                    },
                  );
                }
                return SliverList.builder(
                  itemCount: widget.viewModel.games.length,
                  itemBuilder: (context, index) {
                    final game = widget.viewModel.games[index];
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
