import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:food/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';

void main() => runApp(ChatbotApp());

//https://cameralabs.org/uchebnik/osnovi-fotografii
class ChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      home: ChatbotScreen(),
    );
  }
}

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final videoURL1 = "https://www.youtube.com/watch?v=s8IfCO8VWC8&t=4s";
  final videoURL2 = "https://www.youtube.com/watch?v=xQfGY0zseag";
  final videoURL3 = "https://www.youtube.com/watch?v=HOOKIChuC1k";
  final videoURL4 = "https://www.youtube.com/watch?v=scLQHnGiOnU";

  late YoutubePlayerController _ytcontroller;
  late YoutubePlayerController _ytcontroller2;
  late YoutubePlayerController _ytcontroller3;
  late YoutubePlayerController _ytcontroller4;

  bool showVideo1 = false;
  bool showVideo2 = false;
  bool showVideo3 = false;
  bool showVideo4 = false;

  Offset _offset = Offset(0.0, 0.0);

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = Offset(
        _offset.dx + details.delta.dx,
        _offset.dy + details.delta.dy,
      );
    });
  }

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL1);
    final videoID2 = YoutubePlayer.convertUrlToId(videoURL2);
    final videoID3 = YoutubePlayer.convertUrlToId(videoURL3);
    final videoID4 = YoutubePlayer.convertUrlToId(videoURL4);

    _ytcontroller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    _ytcontroller2 = YoutubePlayerController(
      initialVideoId: videoID2!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    _ytcontroller3 = YoutubePlayerController(
      initialVideoId: videoID3!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    _ytcontroller4 = YoutubePlayerController(
      initialVideoId: videoID4!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    super.initState();
  }

  final List<String> _chatMessages = <String>[
    'Привет, чем я могу тебе помочь?',
  ];
  final Map<String, String> _responses = <String, String>{
    'Как делать хорошие фото?':
        'Хорошие фотографии требуют хорошего света и правильной композиции. Рекомендую ознакомиться с видео-роликом ниже:',
    'В какое время суток делать фото лучше всего?':
        'В первые часы утра и в последние часы дня свет более мягкий и теплый, что может создавать лучшие условия для съемки.',
    'Какие фото сейчас в тренде?':
        'Сейчас очень популярны фото с эффектами сепии, винтажа и черно-белого стиля. Рекомендую ознакомиться с видео-роликом ниже:',
    'дарова мудила': 'даров братан',
    'йоу': 'йо',
    'йит': 'woah',
    'привет' : 'Привет!',
    'Привет' : 'Привет!',
    'Привет!' : 'Привет!',

    'спасибо' : 'Пожалуйста, всегда рад помочь!',
    'Спасибо' : 'Пожалуйста, всегда рад помочь!',
    'спс' : 'Пожалуйста, всегда рад помочь!',
    'Как я могу использовать свет для улучшения моих фотографий?':
        ' Свет очень важен для создания хороших фотографий. Вы можете использовать естественный свет, например, фотографировать на открытом воздухе или около окон, чтобы получить мягкое и равномерное освещение. Вы также можете использовать искусственный свет, такой как лампы, фонарики или вспышки, чтобы создать интересный эффект освещения.',
    'Как я могу улучшить композицию моих фотографий?':
        'Чтобы улучшить композицию своих фотографий, вы можете использовать правило третей или золотое сечение, чтобы расположить объекты в кадре более эстетично. Вы также можете использовать различные углы съемки или режимы кадрирования, чтобы создать более интересную и динамичную композицию.',
    'Как я могу улучшить экспозицию моих фотографий?':
        'Чтобы улучшить экспозицию фотографий, вы можете использовать режимы автоматической экспозиции, такие как приоритет диафрагмы или приоритет выдержки. Эти режимы позволяют вам выбрать параметр, который вы хотите контролировать, а камера автоматически настроит другой параметр для получения правильной экспозиции.',
    'Как я могу получить более резкие фотографии?':
        'Для получения более резких фотографий вы можете использовать штатив или опору для уменьшения вибрации фотоаппарата. Вы также можете увеличить выдержку, чтобы снизить вероятность появления размытия. Не забудьте также, что чистота объектива и чистота датчика изображения также могут повлиять на резкость фотографии.',
    'stop callin':
        'my phone, just leave me alone, yeah, damn it (Yeah) Im not from this zone, Im not from my home, Im not from this planet (Yeah, yeah) Im high on life, my Glock talk to me, it told me, "Go blam it" (Bop, bop) Yeah, fuck what you sayin, you a lil bitch, go talk to your mommy (Mommy)',
  };

  void _showResponse(String question) {
    String response = _responses[question] ??
        'Извините, я не понял ваш вопрос. Попробуйте выбрать из списка предложенных.';

    if (question == 'Как делать хорошие фото?') {
      showVideo1 = true;
    } else if (question == 'Какие фото сейчас в тренде?') {
      showVideo2 = true;
    } else if (question == 'stop callin' ||
        question == 'stop' ||
        question == 'yeat' ||
        question == 'йит') {
      showVideo3 = true;
    } else if (question == 'Как я могу улучшить композицию моих фотографий?') {
      showVideo4 = true;
    }

    setState(() {

      _chatMessages.add('Вы: $question');
      _chatMessages.add('Чат-бот: $response');
      _controller.clear();
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                controller: _scrollController,
                reverse: false,
                itemCount: _chatMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  final String message = _chatMessages[index];
                  return Column(
                    children: [
                      SizedBox(height: 8.0),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: message.startsWith('Вы')
                                  ? [
                                      Colors.pink,
                                      Colors.purple,
                                    ]
                                  : [
                                      Colors.blue,
                                      Colors.cyan,
                                    ],
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: message.startsWith('Вы')
                                ? Icon(Icons.person)
                                : Icon(Icons.android),
                            title: Text(message,
                                style: message.startsWith('Вы')
                                    ? TextStyle(color: Colors.white)
                                    : TextStyle(color: Colors.white)),
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(text: message));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Скопировано в буфер обмена"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (showVideo1)
            Expanded(
              child: Stack(
                children: [
                  YoutubePlayer(
                    controller: _ytcontroller,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                      ),
                      RemainingDuration(),
                      //CurrentPosition(),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          showVideo1 = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (showVideo2)
            Expanded(
              child: Stack(
                children: [
                  YoutubePlayer(
                    controller: _ytcontroller2,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                      ),
                      RemainingDuration(),
                      //CurrentPosition(),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          showVideo2 = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (showVideo3)
            Expanded(
              child: Stack(
                children: [
                  YoutubePlayer(
                    controller: _ytcontroller3,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                      ),
                      RemainingDuration(),
                      //CurrentPosition(),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          showVideo3 = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (showVideo4)
            Expanded(
              child: Stack(
                children: [
                  YoutubePlayer(
                    controller: _ytcontroller4,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                      ),
                      RemainingDuration(),
                      //CurrentPosition(),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          showVideo4 = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoTextField(
                    controller: _controller,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: CupertinoColors.systemGrey5,
                    ),
                    placeholder: 'Введите ваш вопрос',
                  ),
                ),
                const SizedBox(width: 8.0),
                CupertinoButton(
                  onPressed: () => _showResponse(_controller.text),
                  child: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                CupertinoButton(
                  onPressed: () => _showResponse('Как делать хорошие фото?'),
                  child: Text(
                    'Как делать хорошие фото?',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                CupertinoButton(
                  onPressed: () => _showResponse(
                      'В какое время суток делать фото лучше всего?'),
                  child: Text(
                    'В какое время суток делать фото лучше всего?',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                CupertinoButton(
                  onPressed: () => _showResponse('Какие фото сейчас в тренде?'),
                  child: Text(
                    'Какие фото сейчас в тренде?',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                CupertinoButton(
                  onPressed: () => _showResponse(
                      'Как я могу получить более резкие фотографии?'),
                  child: Text(
                    'Как я могу получить более резкие фотографии?',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                CupertinoButton(
                  onPressed: () => _showResponse(
                      'Как я могу улучшить экспозицию моих фотографий?'),
                  child: Text(
                    'Как я могу улучшить экспозицию моих фотографий?',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                CupertinoButton(
                  onPressed: () => _showResponse(
                      'Как я могу улучшить композицию моих фотографий?'),
                  child: Text(
                    'Как я могу улучшить композицию моих фотографий?',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                CupertinoButton(
                  onPressed: () => _showResponse(
                      'Как я могу использовать свет для улучшения моих фотографий?'),
                  child: Text(
                    'Как я могу использовать свет для улучшения моих фотографий?',
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
