import 'package:flame/components.dart';

class Block {
  final Vector2 gridPosition;
  final Type blockType;

  const Block(this.gridPosition, this.blockType);
}
