import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:food/colors.dart';
import 'package:gallery_saver/files.dart';
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
import 'package:gallery_saver/gallery_saver.dart';
import 'package:food/Apis Screen/api_services.dart';
import 'package:http/http.dart' as http;
import 'chat_gpt.dart';
import 'introduction.dart';
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

  final lastVisit =
      prefs.getInt('last_visit') ?? DateTime.now().millisecondsSinceEpoch;

  await prefs.setInt('last_visit', DateTime.now().millisecondsSinceEpoch);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Stream.periodic(Duration(days: 3)).listen((_) async {
    if (DateTime.now().millisecondsSinceEpoch >=
        lastVisit + Duration(days: 3).inMilliseconds) {
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
   Stream.periodic(Duration(days: 1)).listen((_) async {
    if (DateTime.now().millisecondsSinceEpoch >=
        lastVisit + Duration(days: 1).inMilliseconds) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'ИИ сегодня',
        'Посмотрите, что предлагает ИИ прямо сейчас!',
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
          children: [Introduction(), HomeScreen(animation: _animation), HiddenDrawer(), Introduction()],
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

Future<bool> _onBackPressed(BuildContext context) async {
  bool? exitApp = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.power_settings_new, color: Colors.red),
            SizedBox(width: 8),
            Text('Уже уходите?', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Text('Вы уверены, что хотите выйти?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Остаться', style: TextStyle(color: Colors.grey)),
          ),
          CupertinoButton(
            onPressed: () => Navigator.pop(context, true),
            color: Colors.deepPurple,
            child: Text('Да', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );

  if(exitApp != null && exitApp){
    SystemNavigator.pop();
  }

  return exitApp ?? false;
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.animation}) : super(key: key);

  final Animation<Color?> animation;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                      'images/logo3.png',
                      //fit: BoxFit.contain,
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
                        CupertinoButton(
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
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          child: Text(
                            'Начать',
                            style: TextStyle(
                                fontSize: 18,
                                color: CupertinoColors.white,
                                /*fontFamily: 'Ubuntu'*/),
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
  bool _showImage = true;
  /*var sizes = ["Small", "Medium", "Large"];
  var values = ["256x256", "512x512", "1024x1024"];
  String? dropValue;*/
  //var textController = TextEditingController();
  String? image;
  var isLoaded = false;
  String? dropValue = "1024x1024";
  String apiKey = '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';
  String url = 'https://api.openai.com/v1/images/generations';
  TextEditingController inputText = TextEditingController();
  //String text = textController?.text ?? "";

//не работает
  void generateImage() async {
    if (inputText.text.isNotEmpty) {
      var data = {
        "prompt": inputText.text,
        "n": 1,
        "size": "256x256",
      };

      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer ${apiKey}",
            "Content-Type": "application/json"
          },
          body: jsonEncode(data));

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse.containsKey('data')) {
        image = jsonResponse['data'][0]['url'];
        setState(() {});
      } else {
        print('Key "data" not found in API response.');
        print(jsonResponse);
      }
    } else {
      print("Enter something");
    }
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
  void initState() {
    super.initState();
    _colors = [
      Color.fromARGB(255, 5, 9, 247),
      Color.fromARGB(255, 12, 253, 233),
    ];
    // Start animating the colors immediately on screen load
    _animateColors();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CupertinoNavigationBar(
      backgroundColor: Colors.deepPurple,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/carti2.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                      ),
                      SizedBox(width: 8),
                      Text('Выбрать фото'),
                    ],
                  ),
                  color: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  borderRadius: BorderRadius.circular(32),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 8),
                      Text('Сделать фото'),
                    ],
                  ),
                  color: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  borderRadius: BorderRadius.circular(32),
                ),
                const SizedBox(height: 16),
             /* ElevatedButton.icon(
                  icon: const Icon(Icons.memory),
                  label: const Text('Генерация фото с ИИ'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                            backgroundColor: Color.fromARGB(255, 58, 148, 183),
                            resizeToAvoidBottomInset: false,
                            appBar: AppBar(
                              centerTitle: true,
                              title: Text(
                                "Генерация фото с ИИ",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            ),
                            body: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 44,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: TextFormField(
                                                    controller: inputText,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Опишите то, что хотите создать...",
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              width: 300,
                                              height: 44,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: btnColor,
                                                      shape:
                                                          const StadiumBorder()),
                                                  onPressed: () async {
                                                    String result;
                                                    if (inputText
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        isLoaded = false;
                                                        image = '';
                                                      });
                                                      generateImage();

                                                      if (image != null) {
                                                        setState(() {
                                                          // image = result.toString();
                                                          isLoaded = true;
                                                        });
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Введите, пожалуйста, текст"),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child:
                                                      const Text("Создать"))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: isLoaded
                                          ? Image.network(image!)
                                          : Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: whiteColor,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                 Image.asset(
                                                      "assets/loading.gif"),
                                                  SizedBox(height: 12),
                                                  const Text(
                                                    "Создание изображения...",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                                  ],
                                ))),
                      ),
                    );
                  })*/
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

/*const SizedBox(height: 16),
              ElevatedButton.icon(
                  icon: const Icon(Icons.memory),
                  label: const Text('Генерация фото с ИИ'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                            backgroundColor: Color.fromARGB(255, 58, 148, 183),
                            resizeToAvoidBottomInset: false,
                            appBar: AppBar(
                              centerTitle: true,
                              title: Text(
                                "Генерация фото с ИИ",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            ),
                            body: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 44,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: TextFormField(
                                                    controller: inputText,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Опишите то, что хотите создать...",
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              width: 300,
                                              height: 44,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: btnColor,
                                                      shape:
                                                          const StadiumBorder()),
                                                  onPressed: () async {
                                                    String result;
                                                    if (inputText
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        isLoaded = false;
                                                        image = '';
                                                      });
                                                      generateImage();

                                                      if (image != null) {
                                                        setState(() {
                                                          // image = result.toString();
                                                          isLoaded = true;
                                                        });
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Введите, пожалуйста, текст"),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child:
                                                      const Text("Создать"))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: isLoaded
                                          ? Image.network(image!)
                                          : Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: whiteColor,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/loading.gif"),
                                                  SizedBox(height: 12),
                                                  const Text(
                                                    "Создание изображения...",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                                  ],
                                ))),
                      ),
                    );
                  })*/