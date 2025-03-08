import 'package:flame/components.dart';
import 'package:flame_codelab_1/src/config.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';

import '../breakout_game.dart';
import 'play_area.dart';
import 'bat.dart';
import 'brick.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color(0xff1e6091)
            ..style = PaintingStyle.fill,
          children: [CircleHitbox()],
        );

  final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersecPoints, PositionComponent otherObj) {
    super.onCollisionStart(intersecPoints, otherObj);

    if (otherObj is PlayArea) {
      if (intersecPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersecPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersecPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersecPoints.first.y >= game.height) {
        add(RemoveEffect(delay: .35));
      }
    } else if (otherObj is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - otherObj.position.x) /
              otherObj.size.x *
              game.width *
              .3;
    } else if (otherObj is Brick) {
      if (position.y < otherObj.position.y - otherObj.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > otherObj.position.y + otherObj.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < otherObj.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > otherObj.position.x) {
        velocity.x = -velocity.x;
      }
      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
