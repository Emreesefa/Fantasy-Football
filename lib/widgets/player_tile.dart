import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerTile extends StatelessWidget {
  final Player player;
  final VoidCallback onAdd;

  PlayerTile({
    required this.player,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(player.name),
      subtitle: Text('${player.team} vs ${player.opponent}'),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: onAdd,
      ),
    );
  }
}
