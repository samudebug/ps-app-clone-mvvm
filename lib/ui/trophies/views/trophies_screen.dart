import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/trophy_group.dart';
import 'package:ps_app_clone_mvvm/ui/trophies/view_models/trophies_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TrophiesScreen extends StatefulWidget {
  const TrophiesScreen({
    super.key,
    required this.trophyGroup,
    required this.viewModel,
  });
  final TrophyGroup trophyGroup;
  final TrophiesViewModel viewModel;
  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {
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
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.trophyGroup.iconUrl,
              height: 120,
            ),
          ),
          Text(
            widget.trophyGroup.name,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel.getTrophiesCommand,
              builder: (context, child) {
                if (widget.viewModel.getTrophiesCommand.running) {
                  return Skeletonizer(child: ListView(
                    children: List.generate(8, (index) {
                      return ListTile(
                        leading: const ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                          ),
                        ),
                        title: Text('Loading trophy...'),
                        subtitle: Text('Please wait'),
                      );
                    }),
                  ));
                }
                return ListView.builder(
                  itemCount: widget.viewModel.trophies.length,
                  itemBuilder: (context, index) {
                    final trophy = widget.viewModel.trophies[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          trophy.iconUrl,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      title: Text(trophy.name),
                      subtitle: Text(trophy.detail),
                      trailing: Icon(
                        trophy.isEarned ? Icons.check_circle : Icons.circle,
                        color: trophy.isEarned
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
