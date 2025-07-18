import 'package:flutter/material.dart';
import 'package:ps_app_clone_mvvm/domain/models/games/game.dart';

class GameListItem extends StatelessWidget {
  const GameListItem({super.key, required this.game});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 8,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              game.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                  game.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  ),
                Row(spacing: 4,children: [
                  Icon(Icons.timer, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant,),
                  Text('${game.duration.hours}h ${game.duration.minutes}m', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),),
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}
