import 'dart:core';

import 'package:flutter_game_runner/player_progress/player.dart';

class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {
  final List<int> levels = [];

  @override
  Future<List<int>> getFinishedLevels() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return levels;
  }

  @override
  Future<void> saveLevelFinished(int level, int time) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (level < levels.length - 1 && levels[level - 1] > time) {
      levels[level - 1] = time;
    }
  }

  @override
  Future<void> reset() async {
    levels.clear();
  }
}
