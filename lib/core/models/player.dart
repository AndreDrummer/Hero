import 'package:flutter/material.dart';
import 'package:hero/core/models/game_object.dart';

class Player extends GameObject {
  int moveHorizontal = 0;
  int moveVertical = 0;
  double energy = 0.0;
  int speed = 0;

  Map anglesToRadiansConversionTable = {
    'angle45': 0.7853981633974483,
    'angle90': 1.5707963267948966,
    'angle135': 2.3387411976724017,
    'angle180': 3.141592653589793,
    'angle225': 3.9269908169872414,
    'angle270': 4.71238898038469,
    'angle315': 5.497787143782138
  };

  double radians = 0.0;

  Player({
    required double inScreenWidth,
    required double inScreenHeight,
    required String inBaseFilename,
    required int inFrameSkip,
    required int inNumFrames,
    required int inHeight,
    required int inSpeed,
    required int inWidth,
  }) : super(
          inScreenWidth: inScreenWidth,
          inScreenHeight: inScreenHeight,
          inBaseFilename: inBaseFilename,
          inFrameSkip: inFrameSkip,
          inNumFrames: inNumFrames,
          inHeight: inHeight,
          inWidth: inWidth,
        ) {
    speed = inSpeed;
  }

  @override
  Widget draw() {
    return visible
        ? Positioned(
            left: x,
            top: y,
            child: Transform.rotate(
              angle: radians,
              child: frames[currentFrame],
            ),
          )
        : Positioned(child: Container());
  }

  void move() {
    if (x > 0 && moveHorizontal == -1) {
      x = x - speed;
    }
    if (x < (screenWidth - width) && moveHorizontal == 1) {
      x = x + speed;
    }
    if (y > 40 && moveVertical == -1) {
      y = y - speed;
    }
    if (y < (screenHeight - height - 10) && moveVertical == 1) {
      y = y + speed;
    }
  }

  void orientationChanged() {
    radians = 0.0;
    if (moveHorizontal == 1 && moveVertical == -1) {
      radians = anglesToRadiansConversionTable['angle45'];
    } else if (moveHorizontal == 1 && moveVertical == 0) {
      radians = anglesToRadiansConversionTable['angle90'];
    } else if (moveHorizontal == 1 && moveVertical == 1) {
      radians = anglesToRadiansConversionTable['angle135'];
    } else if (moveHorizontal == 0 && moveVertical == 1) {
      radians = anglesToRadiansConversionTable['angle180'];
    } else if (moveHorizontal == -1 && moveVertical == 1) {
      radians = anglesToRadiansConversionTable['angle225'];
    } else if (moveHorizontal == -1 && moveVertical == 0) {
      radians = anglesToRadiansConversionTable['angle270'];
    } else if (moveHorizontal == -1 && moveVertical == -1) {
      radians = anglesToRadiansConversionTable['angle315'];
    }
  }
}
