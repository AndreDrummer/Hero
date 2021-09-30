import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hero/core/input_controller.dart';
import 'package:hero/core/models/enemy.dart';
import 'package:hero/core/models/game_object.dart';
import 'package:hero/core/models/player.dart';

AnimationController? gameLoopController;
late Animation gameLoopAnimation;
Random random = Random();
late double screenHeight;
late double screenWidth;
late GameObject crystal;
late List asteroids;
late Player player;
late List robots;
late List aliens;
late State state;
late List fish;
int score = 0;

late AudioCache audioCache;
late GameObject planet;
List explosions = [];

void firstTimeInitialization(BuildContext inContext, dynamic inState) {
  state = inState;

  audioCache = AudioCache();
  audioCache.loadAll(
    [
      'explosion.mp3',
      'delivery.mp3',
      'thrust.mp3',
      'fill.mp3',
    ],
  );

  screenWidth = MediaQuery.of(inContext).size.width;
  screenHeight = MediaQuery.of(inContext).size.height;

  crystal = GameObject(
    inScreenHeight: screenHeight,
    inScreenWidth: screenWidth,
    inBaseFilename: 'crystal',
    inFrameSkip: 6,
    inNumFrames: 4,
    inHeight: 30,
    inWidth: 32,
  );

  planet = GameObject(
    inScreenHeight: screenHeight,
    inScreenWidth: screenWidth,
    inBaseFilename: 'planet',
    inNumFrames: 1,
    inFrameSkip: 0,
    inHeight: 64,
    inWidth: 64,
  );

  player = Player(
    inScreenHeight: screenHeight,
    inScreenWidth: screenWidth,
    inBaseFilename: 'player',
    inNumFrames: 2,
    inFrameSkip: 6,
    inHeight: 34,
    inWidth: 40,
    inSpeed: 2,
  );

  fish = [
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'fish',
      inMoveDirection: 1,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 4,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'fish',
      inMoveDirection: 1,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 4,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'fish',
      inMoveDirection: 1,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 4,
    ),
  ];

  robots = [
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'robot',
      inMoveDirection: 0,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 3,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'robot',
      inMoveDirection: 0,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 3,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'robot',
      inMoveDirection: 0,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 3,
    ),
  ];
  aliens = [
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'alien',
      inMoveDirection: 1,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 2,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'alien',
      inMoveDirection: 1,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 2,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'alien',
      inMoveDirection: 1,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 2,
    ),
  ];
  asteroids = [
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'asteroid',
      inMoveDirection: 0,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 1,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'asteroid',
      inMoveDirection: 0,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 1,
    ),
    Enemy(
      inScreenHeight: screenHeight,
      inScreenWidth: screenWidth,
      inBaseFilename: 'asteroid',
      inMoveDirection: 0,
      inNumFrames: 2,
      inFrameSkip: 6,
      inHeight: 48,
      inWidth: 48,
      inSpeed: 1,
    ),
  ];

  gameLoopController = AnimationController(
    vsync: inState,
    duration: const Duration(
      milliseconds: 1000,
    ),
  );
  gameLoopAnimation = Tween(begin: 0, end: 17).animate(
    CurvedAnimation(
      parent: gameLoopController!,
      curve: Curves.linear,
    ),
  );

  gameLoopAnimation.addStatusListener((inStatus) {
    if (inStatus == AnimationStatus.completed) {
      gameLoopController!.reset();
      gameLoopController!.forward();
    }
  });

  gameLoopAnimation.addListener(gameLoop);

  resetGame(true);

  InputController.init(player);

  gameLoopController!.forward();
}

void resetGame(bool inResetEnemies) {
  player.energy = 0.0;

  player.x = (screenWidth / 2) - (player.width / 2);
  player.y = screenHeight - player.height - 24;
  player.moveHorizontal = 0;
  player.moveVertical = 0;
  player.orientationChanged();

  crystal.y = 34.0;
  randomlyPositionObject(crystal);

  planet.y = screenHeight - planet.height - 10;
  randomlyPositionObject(planet);

  if (inResetEnemies) {
    List xValsFish = [70.0, 192.0, 312.0];
    List xValsRobots = [64.0, 192.0, 320.0];
    List xValsAliens = [44.0, 192.0, 340.0];
    List xValsAsteroids = [24.0, 192.0, 360.0];
    for (int i = 0; i < 3; i++) {
      fish[i].x = xValsFish[i];
      robots[i].x = xValsRobots[i];
      aliens[i].x = xValsAliens[i];
      asteroids[i].x = xValsAsteroids[i];
      fish[i].y = 110.0;
      robots[i].y = fish[i].y + 120;
      aliens[i].y = robots[i].y + 130;
      asteroids[i].y = aliens[i].y + 140;
      fish[i].visible = true;
      robots[i].visible = true;
      aliens[i].visible = true;
      asteroids[i].visible = true;
    }
  }

  explosions = [];

  player.visible = true;
}

void gameLoop() {
  crystal.animate();

  for (int i = 0; i < 3; i++) {
    fish[i].move();
    fish[i].animate();
    robots[i].move();
    robots[i].animate();
    aliens[i].move();
    aliens[i].animate();
    asteroids[i].move();
    asteroids[i].animate();
  }

  player.move();
  player.animate();

  for (int i = 0; i < explosions.length; i++) {
    explosions[i].animate();
  }

  if (collision(crystal)) {
    transferEnergy(true);
  } else if (collision(planet)) {
    transferEnergy(false);
  } else {
    if (player.energy > 0 && player.energy < 1) {
      player.energy = 0;
    }
  }

  for (int i = 0; i < 3; i++) {
    if (collision(fish[i]) ||
        collision(robots[i]) ||
        collision(aliens[i]) ||
        collision(asteroids[i])) {
      audioCache.play('explosion.mp3');

      player.visible = false;

      GameObject explosion = GameObject(
        inScreenHeight: screenHeight,
        inScreenWidth: screenWidth,
        inBaseFilename: 'explosion',
        inNumFrames: 5,
        inFrameSkip: 4,
        inHeight: 50,
        inWidth: 50,
        inAnimationCallback: () {
          resetGame(false);
        },
      );

      explosion.x = player.x;
      explosion.y = player.y;
      explosions.add(explosion);
      score = score - 50;
      if (score < 0) {
        score = 0;
      }
    }
  }

  state.setState(() {});
}

bool collision(GameObject inObject) {
  if (!player.visible || !inObject.visible) {
    return false;
  }

  num left1 = player.x;
  num right1 = left1 + player.width;
  num top1 = player.y;
  num bottom1 = top1 + player.height;
  num left2 = inObject.x;
  num right2 = left2 + inObject.width;
  num top2 = inObject.y;
  num bottom2 = top2 + inObject.height;

  if (bottom1 < top2) {
    return false;
  }
  if (top1 > bottom2) {
    return false;
  }
  if (right1 < left2) {
    return false;
  }
  return left1 <= right2;
}

void randomlyPositionObject(GameObject inObject) {
  inObject.x =
      (random.nextInt(screenWidth.toInt() - inObject.width)).toDouble();

  if (collision(inObject)) {
    randomlyPositionObject(inObject);
  }
}

void transferEnergy(bool inTouchingCrystal) {
  if (inTouchingCrystal && player.energy < 1) {
    if (player.energy == 0) {
      audioCache.play('fill.mp3');
    }
    player.energy = player.energy + .01;
    if (player.energy >= 1) {
      player.energy = 1;
      randomlyPositionObject(crystal);
    }
  } else if (player.energy > 0) {
    if (player.energy >= 1) {
      audioCache.play('delivery.mp3');
    }
    player.energy = player.energy - .01;
    if (player.energy <= 0) {
      player.energy = 0;
      audioCache.play('explosion.mp3');
      score = score + 100;

      for (int i = 0; i < 3; i++) {
        Function? callback;
        if (i == 0) {
          callback = () {
            resetGame(true);
          };
        }

        fish[i].visible = false;

        GameObject explosion = GameObject(
          inAnimationCallback: callback,
          inScreenHeight: screenHeight,
          inBaseFilename: 'explosion',
          inScreenWidth: screenWidth,
          inNumFrames: 5,
          inFrameSkip: 4,
          inHeight: 50,
          inWidth: 50,
        );

        explosion.x = fish[i].x;
        explosion.y = fish[i].y;
        explosions.add(explosion);
        robots[i].visible = false;

        explosion = GameObject(
          inScreenHeight: screenHeight,
          inBaseFilename: 'explosion',
          inScreenWidth: screenWidth,
          inNumFrames: 5,
          inFrameSkip: 4,
          inHeight: 50,
          inWidth: 50,
        );

        explosion.x = robots[i].x;
        explosion.y = robots[i].y;
        explosions.add(explosion);
        aliens[i].visible = false;

        explosion = GameObject(
          inScreenHeight: screenHeight,
          inBaseFilename: 'explosion',
          inScreenWidth: screenWidth,
          inNumFrames: 5,
          inFrameSkip: 4,
          inHeight: 50,
          inWidth: 50,
        );

        explosion.x = aliens[i].x;
        explosion.y = aliens[i].y;
        explosions.add(explosion);
        asteroids[i].visible = false;

        explosion = GameObject(
          inScreenHeight: screenHeight,
          inBaseFilename: 'explosion',
          inScreenWidth: screenWidth,
          inNumFrames: 5,
          inFrameSkip: 4,
          inHeight: 50,
          inWidth: 50,
        );

        explosion.x = asteroids[i].x;
        explosion.y = asteroids[i].y;
        explosions.add(explosion);
      }
    }
  }
}
