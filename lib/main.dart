import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'src/breakout_game.dart';

void main() {
  final game = BrickBreaker();
  runApp(GameWidget(game: game));
}
