import 'dino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController worldController;
  Dino dino = Dino();

  Duration lastUpdateCall = Duration();
  @override
  void initState() {
    super.initState();
    worldController =
        AnimationController(vsync: this, duration: Duration(days: 99));

    worldController.addListener(_update);
    worldController.forward();
  }

  void _update() {
    dino.update(lastUpdateCall, worldController.lastElapsedDuration);
    lastUpdateCall = worldController.lastElapsedDuration;
  }

  @override
  Widget build(BuildContext context) {
    Rect dinoRect = dino.getRect(MediaQuery.of(context).size, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dino.jump();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: worldController,
              builder: (context, child) {
                Rect dinoRect = dino.getRect(MediaQuery.of(context).size, 0);
                return Positioned(
                  left: dinoRect.left,
                  top: dinoRect.top,
                  width: dinoRect.width,
                  height: dinoRect.height,
                  child: dino.render(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
