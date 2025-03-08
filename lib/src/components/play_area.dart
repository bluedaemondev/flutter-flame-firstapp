import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../breakout_game.dart';

class PlayArea extends RectangleComponent with HasGameReference<BrickBreaker> {
  PlayArea()
      : super(
          paint: Paint()..color = const Color(0xfff2e8cf),
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
