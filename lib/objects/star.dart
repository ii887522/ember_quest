import 'package:ember_quest/ember_quest.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class Star extends SpriteComponent with HasGameRef<EmberQuestGame> {
  final Vector2 _gridPosition;
  final double _xOffset;
  final _velocity = Vector2.zero();

  Star({required Vector2 gridPosition, required double xOffset})
      : _xOffset = xOffset,
        _gridPosition = gridPosition,
        super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    sprite = Sprite(game.images.fromCache('star.png'));

    position = Vector2(
      _gridPosition.x * size.x + _xOffset + size.x / 2,
      game.size.y - _gridPosition.y * size.y - size.y / 2,
    );

    addAll([
      RectangleHitbox(collisionType: CollisionType.passive),
      SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
            duration: 0.75,
            reverseDuration: 0.5,
            infinite: true,
            curve: Curves.easeOut),
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _velocity.x = game.objectSpeed;
    position += _velocity * dt;
    if (position.x < -size.x || game.health <= 0) removeFromParent();
  }
}
