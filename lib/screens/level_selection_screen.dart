import 'package:flutter/material.dart';
import 'package:flutter_game_runner/audio/audio.dart';
import 'package:flutter_game_runner/levels/instructions_dialog.dart';
import 'package:flutter_game_runner/levels/levels.dart';
import 'package:flutter_game_runner/player_progress/player_progress.dart';
// import 'package:flutter_game_runner/screens/screens.dart';
import 'package:flutter_game_runner/style/style.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levelTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.4,
        );
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection.color,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     GoRouter.of(context).go('/');
      //   },
      //   child: const Icon(
      //     Icons.chevron_left,
      //   ),
      // ),
      floatingActionButton: WobblyButton(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        child: const Text('Menu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select level',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 16),
                  NesButton(
                    type: NesButtonType.normal,
                    child: NesIcon(
                      iconData: NesIcons.questionMark,
                    ),
                    onPressed: () {
                      NesDialog.show(
                        context: context,
                        builder: (_) => const InstructionsDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
            // width: double.infinity,
          ),
          Expanded(
            child: SizedBox(
              width: 450,
              child: ListView(
                children: [
                  for (final level in gameLevels)
                    ListTile(
                      enabled: playerProgress.levels.length >= level.number - 1,
                      onTap: () {
                        final audioController = context.read<AudioController>();
                        audioController.playSfx(SfxType.buttonTap);

                        GoRouter.of(context)
                            .go('/play/session/${level.number}');
                      },
                      leading: Text(
                        level.number.toString(),
                        style: levelTextStyle,
                      ),
                      title: Row(
                        children: [
                          Text(
                            'Level #${level.number}',
                            style: levelTextStyle,
                          ),
                          if (playerProgress.levels.length < level.number - 1)
                            ...[],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
