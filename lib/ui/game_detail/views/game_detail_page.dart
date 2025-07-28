import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';
import 'package:ps_app_clone_mvvm/routing/routes.dart';
import 'package:ps_app_clone_mvvm/ui/game_detail/view_models/game_detail_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameDetailPage extends StatefulWidget {
  const GameDetailPage({
    super.key,
    required this.game,
    required this.viewModel,
  });
  final Game game;
  final GameDetailViewModel viewModel;
  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.game.imageUrl,
                width: 120,
                height: 120,
              ),
            ),
            Text(
              widget.game.name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.viewModel.getTrophyGroupsCommand,
                builder: (context, child) {
                  if (widget.viewModel.getTrophyGroupsCommand.running) {
                    return Skeletonizer(child: ListView(
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                              ),
                            ),
                          ),
                          title: Text('Loading trophy groups...'),
                        ),
                      ],
                    ));
                  }
                  return ListView.builder(
                    itemCount: widget.viewModel.trophyGroups.length,
                    itemBuilder: (context, index) {
                      final trophyGroup = widget.viewModel.trophyGroups[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            trophyGroup.iconUrl,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text(trophyGroup.name),
                        onTap: () {
                          context.push(
                            Routes.trophy_group_details(
                              widget.game.id,
                              trophyGroup.id,
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
