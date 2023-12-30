import 'package:ember_quest/actors/water_enemy.dart';
import 'package:ember_quest/ember_quest.dart';
import 'package:ember_quest/objects/ground_block.dart';
import 'package:ember_quest/objects/platform_block.dart';
import 'package:ember_quest/objects/star.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

class EmberPlayer extends SpriteAnimationComponent
    with HasGameRef<EmberQuestGame>, KeyboardHandler, CollisionCallbacks {
  int _horizontalDirection = 0;
  final _velocity = Vector2.zero();
  final _moveSpeed = 200.0;
  final _fromAbove = Vector2(0, -1);
  var _isOnGround = false;
  final _gravity = 15.0;
  final _jumpSpeed = 1200.0;
  final _terminalVelocity = 150.0;
  bool _hasJumped = false;
  bool _hitByEnemy = false;

  EmberPlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.12,
        textureSize: Vector2.all(16),
      ),
    );

    add(CircleHitbox());
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _horizontalDirection = 0;

    _horizontalDirection += keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft)
        ? -1
        : 0;

    _horizontalDirection += keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight)
        ? 1
        : 0;

    _hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _velocity.x = _horizontalDirection * _moveSpeed;
    // Apply basic gravity
    _velocity.y += _gravity;

    if (_hasJumped) {
      if (_isOnGround) {
        _velocity.y = -_jumpSpeed;
        _isOnGround = false;
      }

      _hasJumped = false;
    }

    // Prevent ember from jumping to crazy fast as well as descending too fast
    // and crashing through the ground or a platform
    _velocity.y = _velocity.y.clamp(-_jumpSpeed, _terminalVelocity);

    game.objectSpeed = 0;

    // Prevent ember from going backward at the screen edge
    if (position.x - 36 <= 0 && _horizontalDirection < 0) {
      _velocity.x = 0;
    }

    // Prevent ember from going beyong half screen
    if (position.x + 64 >= game.size.x / 2 && _horizontalDirection > 0) {
      _velocity.x = 0;
      game.objectSpeed = -_moveSpeed;
    }

    position += _velocity * dt;

    if (_horizontalDirection < 0 && scale.x > 0 ||
        _horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    // If ember fell in pit, then game over
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    if (game.health <= 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collisionNormal is almost upwards
        // ember must be on ground
        if (_fromAbove.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        // Resolve collision by moving ember along collision normal by
        // separation distance
        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is Star) {
      other.removeFromParent();
      ++game.starsCollected;
    }

    if (other is WaterEnemy) {
      _hit();
    }
  }

  void _hit() {
    if (!_hitByEnemy) {
      --game.health;
      _hitByEnemy = true;
    }

    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 6,
        ),
      )..onComplete = () => _hitByEnemy = false,
    );
  }
}
