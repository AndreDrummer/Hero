import 'package:flutter/material.dart';

class GameObject {
  Function? animationCallback;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  String baseFilename = '';
  int currentFrame = 0;
  bool visible = true;
  int frameCount = 0;
  int numFrames = 0;
  int frameSkip = 0;
  List frames = [];
  double x = 0.0;
  double y = 0.0;
  int height = 0;
  int width = 0;

  GameObject({
    required String inBaseFilename,
    required double inScreenHeight,
    required double inScreenWidth,
    Function? inAnimationCallback,
    required int inFrameSkip,
    required int inNumFrames,
    required int inHeight,
    required int inWidth,
  }) {
    animationCallback = inAnimationCallback;
    screenHeight = inScreenHeight;
    baseFilename = inBaseFilename;
    screenWidth = inScreenWidth;
    frameSkip = inFrameSkip;
    numFrames = inNumFrames;
    height = inHeight;
    width = inWidth;

    for (int i = 0; i < inNumFrames; i++) {
      frames.add(Image.asset('assets/$baseFilename-$i.png'));
    }
  }

  void animate() {
    frameCount = frameCount + 1;

    if (frameCount > frameSkip) {
      frameCount = 0;
      currentFrame = currentFrame + 1;

      if (currentFrame == numFrames) {
        currentFrame = 0;
        animationCallback?.call();
      }
    }
  }

  Widget draw() {
    return visible
        ? Positioned(left: x, top: y, child: frames[currentFrame])
        : Positioned(child: Container());
  }
}
