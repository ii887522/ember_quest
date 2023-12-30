import 'dart:math';

import 'package:ember_quest/ember_quest.dart';
import 'package:ember_quest/managers/segment_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class GroundBlock extends SpriteComponent with HasGameRef<EmberQuestGame> {
  final _blockKey = UniqueKey();
  final Vector2 gridPosition;
  final double xOffset;
  final Vector2 _velocity = Vector2.zero();

  GroundBlock({required this.gridPosition, required this.xOffset})
      : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    sprite = Sprite(game.images.fromCache('ground.png'));

    position = Vector2(
      gridPosition.x * size.x + xOffset,
      game.size.y - gridPosition.y * size.y,
    );

    add(RectangleHitbox(collisionType: CollisionType.passive));

    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
      game.lastBlockKey = _blockKey;
      game.lastBlockXPosition = position.x + size.x;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _velocity.x = game.objectSpeed;
    position += _velocity * dt;

    if (gridPosition.x == 9 && game.lastBlockKey == _blockKey) {
      game.lastBlockXPosition = position.x + size.x - 10;
    }

    if (position.x < -size.x) {
      removeFromParent();

      if (gridPosition.x == 0) {
        game.loadGameSegments(
          Random().nextInt(segments.length),
          game.lastBlockXPosition,
        );
      }
    }

    if (game.health <= 0) removeFromParent();
  }
}
