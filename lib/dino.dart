import 'package:flutter/material.dart';

const int GRAVITY_PPSPS = 2000;
enum DinoState {
  running,
  jumping,
}

class Sprite {
  String imagePath;
  int imageWidth;
  int imageHeight;
}

abstract class GameObject {
  Widget render();
  Rect getRect(Size screenSize, double runDistance);
  void update(Duration lastTime, Duration elapsedTime) {}
}

Sprite dinoSprite = Sprite()
  // basically a placeholder because we do the sprite animations separately
  ..imagePath = "Assets/dino/dino_01.png"
  ..imageWidth = 88
  ..imageHeight = 94;

class Dino extends GameObject {
  int frame = 1;

  double dispY = 0; // displacement from the ground (смещение от земли)
  double velY = 0; //velocity value

  DinoState state = DinoState.running;

  @override
  Widget render() {
    return Image.asset(
      "Assets/dino/dino_0$frame.png",
      gaplessPlayback: true,
    );
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        screenSize.width / 10,
        4 / 7 * screenSize.height - dinoSprite.imageHeight - dispY,
        dinoSprite.imageWidth.toDouble(),
        dinoSprite.imageHeight.toDouble());
  }

  @override
  void update(Duration lastTime, Duration elapsedTime) {
    double elapsedSeconds =
        ((elapsedTime.inMilliseconds - lastTime.inMilliseconds) / 1000);

    dispY += velY * elapsedSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
    } else {
      velY -= GRAVITY_PPSPS * elapsedSeconds;
    }

    if (velY == 0) {
      state = DinoState.running;
    }

    frame =
        (elapsedTime.inMilliseconds / 100).floor() % 2 + 1; //переключение кадра
  }

  void jump() {
    if (state != DinoState.jumping) {
      velY = 650;
      state = DinoState.jumping;
    }
  }
}
