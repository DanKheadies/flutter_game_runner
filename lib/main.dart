import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_runner/app_lifecycle/app_lifecycle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: const SizedBox(),
    );
  }
}
