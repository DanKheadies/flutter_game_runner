import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_game_runner/audio/audio.dart';
import 'package:flutter_game_runner/flame_game/flame_game.dart';

enum PlayerState {
  falling,
  jumping,
  running,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with
        CollisionCallbacks,
        HasWorldReference<EndlessWorld>,
        HasGameReference<EndlessRunner> {
  final void Function({int amount}) addScore;
  final VoidCallback resetScore;

  Player({
    required this.addScore,
    required this.resetScore,
    super.position,
  }) : super(
          size: Vector2.all(150),
          anchor: Anchor.center,
          priority: 1,
        );

  final double jumpLength = 600;
  final Vector2 lastPosition = Vector2.zero();

  double gravityVelocity = 0;

  bool get inAir => (position.y + size.y / 2) < world.groundLevel;
  bool get isFalling => lastPosition.y < position.y;

  @override
  Future<void> onLoad() async {
    animations = {
      PlayerState.running: await game.loadSpriteAnimation(
        'dash/dash_running.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2.all(16),
        ),
      ),
      PlayerState.jumping: SpriteAnimation.spriteList(
        [
          await game.loadSprite('dash/dash_jumping.png'),
        ],
        stepTime: double.infinity,
      ),
      PlayerState.falling: SpriteAnimation.spriteList(
        [
          await game.loadSprite('dash/dash_falling.png'),
        ],
        stepTime: double.infinity,
      ),
    };

    current = PlayerState.running;
    lastPosition.setFrom(position);

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (inAir) {
      gravityVelocity += world.gravity * dt;
      position.y += gravityVelocity;
      if (isFalling) {
        current = PlayerState.falling;
      }
    }

    final belowGround = position.y + size.y / 2 > world.groundLevel;
    if (belowGround) {
      position.y = world.groundLevel - size.y / 2;
      gravityVelocity = 0;
      current = PlayerState.running;
    }

    lastPosition.setFrom(position);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Obstacle) {
      game.audioController.playSfx(SfxType.damage);
      resetScore();
      add(
        HurtEffect(),
      );
    } else if (other is Point) {
      game.audioController.playSfx(SfxType.score);
      other.removeFromParent();
      addScore();
    }
  }

  void jump(Vector2 towards) {
    current = PlayerState.jumping;

    final jumpEffect = JumpEffect(
      towards..scaleTo(jumpLength),
    );

    if (!inAir) {
      game.audioController.playSfx(SfxType.jump);
      add(jumpEffect);
    }
  }
}
