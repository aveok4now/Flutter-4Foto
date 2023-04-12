import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'hidden_drawer.dart';
import 'image_screen.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
//mport 'package:flutter_sentry/flutter_sentry.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cron/cron.dart';
import 'dart:async';
import 'package:undo/undo.dart';


/*void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();


  final lastVisit = prefs.getInt('last_visit') ?? DateTime.now().millisecondsSinceEpoch;

  
  await prefs.setInt('last_visit', DateTime.now().millisecondsSinceEpoch);

  
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  
  Stream.periodic(Duration(seconds: 5)).listen((_) async {
    if (DateTime.now().millisecondsSinceEpoch >= lastVisit + 5000) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Улучшайте свои фото',
        'Давно Вас не было! Пора улучшать свои фото!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            importance: Importance.max,
            ticker: 'ticker',
          ),
        ),
      );
    }
  });

  runApp(const MyApp());
}*/

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  
  final lastVisit = prefs.getInt('last_visit') ?? DateTime.now().millisecondsSinceEpoch;

  
  await prefs.setInt('last_visit', DateTime.now().millisecondsSinceEpoch);

  
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  
  Stream.periodic(Duration(days: 3)).listen((_) async {
    if (DateTime.now().millisecondsSinceEpoch >= lastVisit + Duration(days: 3).inMilliseconds) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Улучшайте свои фото',
        'Давно Вас не было! Пора улучшать свои фото!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            importance: Importance.max,
            ticker: 'ticker',
          ),
        ),
      );
    }
  });

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = AnimationController(
      vsync: MyVSync(),
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    final Animation<Color?> _animation = ColorTween(
      begin: const Color(0xFFD63AF9),
      end: const Color(0xFF4157D8),
    ).animate(_controller);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4Editor',
       theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        body: Stack(
      children:[
        HomeScreen(animation: _animation),
        HiddenDrawer()],
     
        ),
    ),
    );
  }
}


class MyVSync extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'vsync');
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.animation}) : super(key: key);

  final Animation<Color?> animation;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  animation.value!,
                  animation.value!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 33,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'images/logo.png',
                    //fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      '© NO LABEL, 2023',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TypewriterAnimatedTextKit(
                        repeatForever: true,
                        speed: Duration(milliseconds: 100),
                        pause: Duration(milliseconds: 5000),
                        text: [
                          'Начни улучшать свои фото прямо сейчас',
                        ],
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const EditorScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: const Text(
                          'Начать',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late List<Color> _colors;



  @override
  void initState() {
    super.initState();
    _colors = [
      Color.fromARGB(255, 5, 9, 247),
      Color.fromARGB(255, 12, 253, 233),
    ];
    // Start animating the colors immediately on screen load
    _animateColors();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
    if (!isAllowed){
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  }

  void _animateColors() async {
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      _colors = _colors.reversed.toList();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _colors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final pickedFile = await ImagePicker().getImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageScreen(imagePath: pickedFile.path),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Выбрать фото'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final pickedFile = await ImagePicker().getImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageScreen(imagePath: pickedFile.path),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Сделать фото'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
