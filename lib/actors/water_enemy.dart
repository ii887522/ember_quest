import 'package:ember_quest/ember_quest.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class WaterEnemy extends SpriteAnimationComponent
    with HasGameRef<EmberQuestGame> {
  final Vector2 _gridPosition;
  double _xOffset;
  final Vector2 _velocity = Vector2.zero();

  WaterEnemy({required Vector2 gridPosition, required double xOffset})
      : _xOffset = xOffset,
        _gridPosition = gridPosition,
        super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.7,
        textureSize: Vector2.all(16),
      ),
    );

    position = Vector2(
      _gridPosition.x * size.x + _xOffset,
      game.size.y - _gridPosition.y * size.y,
    );

    addAll([
      RectangleHitbox(collisionType: CollisionType.passive),
      MoveEffect.by(
        Vector2(-2 * size.x, 0),
        EffectController(duration: 3, alternate: true, infinite: true),
      )
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
