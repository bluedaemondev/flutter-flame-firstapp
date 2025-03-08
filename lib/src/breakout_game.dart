import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';

import 'components/components.dart';
import 'config.dart';

enum GameState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );
  final ValueNotifier<int> score = ValueNotifier(0);
  double get width => size.x;
  double get height => size.y;
  final rand = math.Random();

  late GameState _playState;
  GameState get playState => _playState;
  set playState(GameState state){
    _playState = state;
    switch (state) {
      case GameState.welcome:
      case GameState.gameOver:
      case GameState.won:
        overlays.add(playState.name);
        break;
      case GameState.playing:
        overlays.remove(GameState.welcome.name);
        overlays.remove(GameState.gameOver.name);
        overlays.remove(GameState.won.name);
        break;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());
    playState = GameState.welcome;
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  void startGame(){
    if(playState == GameState.playing)return;
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = GameState.playing;
    score.value = 0;

    world.add(Ball(
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4), 
          difficultyModifier: difficultyModifier));

    world.add(Bat(cornerRadius: const Radius.circular(ballRadius/2),
     position: Vector2(width/2, height*.95), 
     size: Vector2(batWidth,batHeight)));

    world.addAll([         
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i],
          ),
    ]);

  }

   @override
   KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        world.children.query<Bat>().first.moveBy(-batStep);
        break;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        world.children.query<Bat>().first.moveBy(batStep);
        break;
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
        break;   
    }
    return KeyEventResult.handled;
  }
  @override
  Color backgroundColor() => const Color(0xfff2e8cf);
}