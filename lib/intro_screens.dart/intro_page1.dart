import 'package:flutter/material.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Decoration> _animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _animation = DecorationTween(
      begin: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6A00FF),
            Color(0xFF8C9EFF),
          ],
        ),
      ),
      end: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8C9EFF),
            Color(0xFF6A00FF),
          ],
        ),
      ),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Curve of the animation
    ));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              "images/ai.png",
              height: 250,
            ),
            const Spacer(),
            Text(
              "Найди вдохновение \n уже сегодня!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Raleway',
                  fontSize: 32,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "Изображения, созданные ИИ, чат-бот, который даст полезные советы по улучшению и редактированию твоих фото.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Ubuntu',
              ),
            ),
            const Spacer(),
            Positioned(
              bottom: 10.0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '4Foto v.1.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      /*body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return AnimatedContainer(
            duration: Duration(seconds: 2), // Duration of the AnimatedContainer animation
            decoration: _animation.value,
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Text(
                      'Добро пожаловать',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '4Editor v.1.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),*/
    );
  }
}



//© NO LABEL, 2023