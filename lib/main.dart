import 'package:ember_quest/ember_quest.dart';
import 'package:ember_quest/overlays/game_over.dart';
import 'package:ember_quest/overlays/main_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(GameWidget.controlled(
    gameFactory: EmberQuestGame.new,
    overlayBuilderMap: {
      'MainMenu': (_, game) => MainMenu(game: game as EmberQuestGame),
      'GameOver': (_, game) => GameOver(game: game as EmberQuestGame),
    },
    initialActiveOverlays: const ['MainMenu'],
  ));
}
