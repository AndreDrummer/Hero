import "package:flutter/material.dart";
import 'package:hero/core/models/player.dart';

class InputController {
  static late double touchAnchorX;
  static late double touchAnchorY;
  static int moveSensitivity = 20;
  static late Player player;

  static void init(Player inPlayer) {
    player = inPlayer;
  }

  static void onPanStart(DragStartDetails inDetails) {
    touchAnchorX = inDetails.globalPosition.dx;
    touchAnchorY = inDetails.globalPosition.dy;
    player.moveHorizontal = 0;
    player.moveVertical = 0;
  }

  static void onPanUpdate(DragUpdateDetails inDetails) {
    if (inDetails.globalPosition.dx < touchAnchorX - moveSensitivity) {
      player.moveHorizontal = -1;
      player.orientationChanged();
    } else if (inDetails.globalPosition.dx > touchAnchorX + moveSensitivity) {
      player.moveHorizontal = 1;
      player.orientationChanged();
    } else {
      player.moveHorizontal = 0;
      player.orientationChanged();
    }
    if (inDetails.globalPosition.dy < touchAnchorY - moveSensitivity) {
      player.moveVertical = -1;
      player.orientationChanged();
    } else if (inDetails.globalPosition.dy > touchAnchorY + moveSensitivity) {
      player.moveVertical = 1;
      player.orientationChanged();
    } else {
      player.moveVertical = 0;
      player.orientationChanged();
    }
  }

  static void onPanEnd(dynamic inDetails) {
    player.moveHorizontal = 0;
    player.moveVertical = 0;
  }
}
