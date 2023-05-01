import 'package:flutter/material.dart';
import 'package:food/hidden_drawer.dart';
import 'package:food/intro_screens.dart/inro_page3.dart';
import 'package:food/intro_screens.dart/intro_page1.dart';
import 'package:food/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intro_screens.dart/inro_page2.dart';
import 'package:vibration/vibration.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    final AnimationController _controller2 = AnimationController(
      vsync: MyVSync(),
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    final Animation<Color?> _animation = ColorTween(
      begin: const Color(0xFFD63AF9),
      end: const Color(0xFF4157D8),
    ).animate(_controller2);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Vibration.vibrate(duration: 30, amplitude: 3);
                    _controller.jumpToPage(2);
                  },
                  child: Text('Проп.', style: TextStyle(fontFamily: 'Raleway'),),
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Vibration.vibrate(duration: 30, amplitude: 3);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                //return HomeScreen(animation: _animation);
                                return HiddenDrawer();
                              },
                            ),
                          );
                        },
                        child: Text('Поехали', style: TextStyle(fontFamily: 'Raleway'),),
                      )
                    : GestureDetector(
                        onTap: () {
                          Vibration.vibrate(duration: 30, amplitude: 3);
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Далее', style: TextStyle(fontFamily: 'Raleway'),)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
