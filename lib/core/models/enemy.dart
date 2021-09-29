import 'package:hero/core/models/game_object.dart';

class Enemy extends GameObject {
  int speed = 0;
  int moveDirection = 0;

  Enemy({
    required double inScreenWidth,
    required double inScreenHeight,
    required String inBaseFilename,
    required int inMoveDirection,
    required int inFrameSkip,
    required int inNumFrames,
    required int inHeight,
    required int inSpeed,
    required int inWidth,
  }) : super(
          inScreenHeight: inScreenHeight,
          inBaseFilename: inBaseFilename,
          inScreenWidth: inScreenWidth,
          inFrameSkip: inFrameSkip,
          inNumFrames: inNumFrames,
          inHeight: inHeight,
          inWidth: inWidth,
        ) {
    speed = inSpeed;
    moveDirection = inMoveDirection;
  }

  void move() {
    if (moveDirection == 1) {
      x = x + speed;
      if (x > screenWidth + width) {
        x = -width.toDouble();
      }
    } else {
      x = x - speed;
      if (x < -width) {
        x = screenWidth + width.toDouble();
      }
    }
  }
}
