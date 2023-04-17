import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:food/midjourney_page.dart';
import 'package:food/settings_page.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'chat_gpt.dart';
import 'chatscreen.dart';
import 'links.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => HiddenDrawerState();
}

class HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final AnimationController _controller = AnimationController(
    vsync: MyVSync(),
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);
  get _animation => ColorTween(
        begin: const Color(0xFFD63AF9),
        end: const Color(0xFF4157D8),
      ).animate(_controller);

  final myTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.white,
    fontFamily: 'Ubuntu',
  );

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: '4Editor',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.white,
        ),
        HomeScreen(animation: _animation),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Создано с ИИ',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.white,
        ),
        JourneyPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Чат-бот',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.white,
        ),
      ChatbotScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'О программе',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.white,
        ),
        SettingsPage(),
      ),
      
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Color.fromARGB(255, 84, 138, 218),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 60,
      contentCornerRadius: 30,
      );
      //tittleAppBar: 
  }
}
