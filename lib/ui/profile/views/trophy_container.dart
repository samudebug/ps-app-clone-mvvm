import 'package:flutter/material.dart';
import 'package:ps_app_clone_mvvm/domain/models/profile/trophy_summary.dart';

class TrophyContainer extends StatelessWidget {
  const TrophyContainer({super.key, required this.trophySummary});
  final TrophySummary trophySummary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          trophyItem(context, 'Platinum', trophySummary.platinum, Colors.blue),
          trophyItem(context, 'Bronze', trophySummary.bronze, Colors.brown),
          trophyItem(context, 'Silver', trophySummary.silver, Colors.grey),
          trophyItem(context, 'Gold', trophySummary.gold, Colors.yellow),
        ],
      ),
    );
  }

  Column trophyItem(BuildContext context, String label, int count, Color color) {
    return Column(
      children: [
        Icon(
          Icons.gamepad,
          size: 50,
          color: color,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
