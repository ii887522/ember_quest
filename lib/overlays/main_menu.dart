import 'package:ember_quest/ember_quest.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final EmberQuestGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ember Quest',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('MainMenu');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Color.fromRGBO(0, 0, 0, 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '''Use WASD or Arrow keys for movement.
Space bar to jump.
Collect as many stars as you can and avoid enemies!''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
