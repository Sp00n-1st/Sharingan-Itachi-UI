import 'dart:async';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  bool isOn = false;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation =
        //tween adalah untuk menghasilkan nilai ticker
        Tween<double>(begin: 6 * pi, end: 0).animate(controller!)
          ..addListener(() {
            setState(() {});
          })
          //ini adalah untuk mengecek status jika animasi
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller!.repeat();
            } else if (status == AnimationStatus.dismissed) {
              controller!.forward();
            }
          });

    controller!.forward();
  }

  //agar tidak memori leak maka di buat dispose()

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isOn = true;
        controller!.duration = const Duration(seconds: 7);
      });
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.red.shade800,
          body: Stack(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 100, 20, 0),
              width: 380,
              child: RotatingTransform(
                  doubleAnimation: animation,
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 2),
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns: controller!,
                      child: child,
                    ),
                    child: (isOn)
                        ? Roulette(
                            spins: 0,
                            child: ZoomIn(
                              duration: const Duration(seconds: 2),
                              child: const Image(
                                key: ValueKey(1),
                                image: AssetImage(
                                  'assets/MS.png',
                                ),
                              ),
                            ),
                          )
                        : ZoomIn(
                            duration: const Duration(seconds: 2),
                            child: const Image(
                                key: ValueKey(2),
                                image: AssetImage('assets/sharingan.png')),
                          ),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/itachi.png'),
            )
          ])),
    );
  }
}

class RotatingTransform extends StatelessWidget {
  final Widget? child;
  final Animation<double>? doubleAnimation;

  const RotatingTransform({super.key, this.child, this.doubleAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: doubleAnimation!,
        builder: (context, child) {
          return Transform.rotate(
            angle: doubleAnimation!.value,
            child: child,
          );
        },
        child: child);
  }
}
