import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hero/core/game_core.dart';
import 'package:hero/core/input_controller.dart';

void main() => runApp(const FlutterHero());

class FlutterHero extends StatelessWidget {
  const FlutterHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    return const MaterialApp(
      title: 'FlutterHero',
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (gameLoopController == null) {
      firstTimeInitialization(context, this);
    }

    List<Widget> stackChildren = [
      Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Positioned(
        left: 4,
        top: 2,
        child: Text(
          'Score: ${score.toString().padLeft(4, '0')}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      Positioned(
        left: 120,
        top: 2,
        width: screenWidth - 124,
        height: 22,
        child: LinearProgressIndicator(
          value: player.energy,
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation(Colors.red),
        ),
      ),
      crystal.draw()
    ];

    for (int i = 0; i < 3; i++) {
      stackChildren.add(fish[i].draw());
      stackChildren.add(robots[i].draw());
      stackChildren.add(aliens[i].draw());
      stackChildren.add(asteroids[i].draw());
    }

    stackChildren.add(planet.draw());
    stackChildren.add(player.draw());

    for (int i = 0; i < explosions.length; i++) {
      stackChildren.add(explosions[i].draw());
    }

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: InputController.onPanUpdate,
        onPanStart: InputController.onPanStart,
        onPanEnd: InputController.onPanEnd,
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }
}
