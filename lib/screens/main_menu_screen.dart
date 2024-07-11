import 'package:flutter/material.dart';
import 'package:flutter_game_runner/audio/audio.dart';
import 'package:flutter_game_runner/screens/screens.dart';
import 'package:flutter_game_runner/settings/settings.dart';
import 'package:flutter_game_runner/style/style.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain.color,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/banner.png',
                filterQuality: FilterQuality.none,
              ),
              const SizedBox(
                height: 10,
                width: double.infinity,
              ),
              Transform.rotate(
                angle: -0.1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Text(
                    'A Flutter game template.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Press Start 2P',
                      fontSize: 32,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WobblyButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/play');
              },
              child: const Text('Play'),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            WobblyButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.audioOn,
                builder: (context, audioOn, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleAudioOn(),
                    icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            const Text('Built with Flame'),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
