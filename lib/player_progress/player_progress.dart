import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_game_runner/player_progress/player.dart';

// TODO: convert to bloc
class PlayerProgress extends ChangeNotifier {
  final PlayerProgressPersistence localStore;

  PlayerProgress({PlayerProgressPersistence? store})
      : localStore = store ?? LocalStoragePlayerProgressPersistence() {
    unawaited(getLatestFromStore());
  }

  List<int> levelsFinished = [];

  List<int> get levels => levelsFinished;

  Future<void> getLatestFromStore() async {
    final finishedLevels = await localStore.getFinishedLevels();
    if (!listEquals(finishedLevels, levelsFinished)) {
      levelsFinished = finishedLevels;
      notifyListeners();
    }
  }

  void reset() {
    localStore.reset();
    levelsFinished.clear();
    notifyListeners();
  }

  void setLevelFinished(int level, int time) {
    if (level < levelsFinished.length - 1) {
      final currentTime = levelsFinished[level - 1];
      if (time < currentTime) {
        levelsFinished[level - 1] = time;
        notifyListeners();
        unawaited(
          localStore.saveLevelFinished(
            level,
            time,
          ),
        );
      }
    } else {
      levelsFinished.add(time);
      notifyListeners();
      unawaited(
        localStore.saveLevelFinished(
          level,
          time,
        ),
      );
    }
  }
}
