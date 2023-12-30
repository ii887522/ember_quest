import 'package:ember_quest/actors/ember.dart';
import 'package:ember_quest/actors/water_enemy.dart';
import 'package:ember_quest/managers/segment_manager.dart';
import 'package:ember_quest/objects/ground_block.dart';
import 'package:ember_quest/objects/platform_block.dart';
import 'package:ember_quest/objects/star.dart';
import 'package:ember_quest/overlays/hud.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class EmberQuestGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  var objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  var starsCollected = 0;
  var health = 3;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png'
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;

    _initializeGame(true);
  }

  @override
  Color backgroundColor() => const Color.fromARGB(255, 173, 223, 247);

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case const (GroundBlock):
          world.add(
            GroundBlock(
                gridPosition: block.gridPosition, xOffset: xPositionOffset),
          );

          break;
        case const (PlatformBlock):
          world.add(
            PlatformBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );

          break;
        case const (Star):
          world.add(
            Star(gridPosition: block.gridPosition, xOffset: xPositionOffset),
          );

          break;
        case const (WaterEnemy):
          world.add(
            WaterEnemy(
                gridPosition: block.gridPosition, xOffset: xPositionOffset),
          );

          break;
      }
    }
  }

  void _initializeGame(bool loadHud) {
    if (loadHud) {
      camera.viewport.add(Hud());
    }

    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; ++i) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    world.add(EmberPlayer(position: Vector2(128, canvasSize.y - 128)));
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    _initializeGame(false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (health <= 0) overlays.add('GameOver');
  }
}
