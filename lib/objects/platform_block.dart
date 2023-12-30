import 'package:ember_quest/ember_quest.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlatformBlock extends SpriteComponent with HasGameRef<EmberQuestGame> {
  final Vector2 _gridPosition;
  final double _xOffset;
  final _velocity = Vector2.zero();

  PlatformBlock({required Vector2 gridPosition, required double xOffset})
      : _xOffset = xOffset,
        _gridPosition = gridPosition,
        super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    sprite = Sprite(game.images.fromCache('block.png'));

    position = Vector2(
      _gridPosition.x * size.x + _xOffset,
      game.size.y - _gridPosition.y * size.y,
    );

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _velocity.x = game.objectSpeed;
    position += _velocity * dt;
    if (position.x < -size.x || game.health <= 0) removeFromParent();
  }
}
