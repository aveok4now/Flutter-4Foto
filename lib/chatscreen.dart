import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:food/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  final videoURL = "https://www.youtube.com/watch?v=s8IfCO8VWC8&t=4s";

  late YoutubePlayerController _ytcontroller;
  bool showVideo = false;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _ytcontroller =YoutubePlayerController(
      initialVideoId: videoID!,
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
        'Хорошие фотографии требуют хорошего света и правильной композиции.',
    'В какое время суток делать фото лучше всего?':
        'В первые часы утра и в последние часы дня свет более мягкий и теплый, что может создавать лучшие условия для съемки.',
    'Какие эффекты сейчас в тренде?':
        'Сейчас очень популярны эффекты сепии, винтажа и черно-белого стиля.',
    'дарова мудила': 'даров братан',
    'йоу' : 'йо', 
    'stop callin' : 'my phone, just leave me alone, yeah, damn it (Yeah) Im not from this zone, Im not from my home, Im not from this planet (Yeah, yeah) Im high on life, my Glock talk to me, it told me, "Go blam it" (Bop, bop) Yeah, fuck what you sayin, you a lil bitch, go talk to your mommy (Mommy)',
  };



  void _showResponse(String question) {
    String response =
        _responses[question] ?? 'Извините, я не понял ваш вопрос.';

    if (question == 'Как делать хорошие фото?') {
       showVideo = true;
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
          
          if (showVideo)
          YoutubePlayer(
            controller: _ytcontroller, 
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
              ),
              IconButton(
      icon: Icon(Icons.close, color: whiteColor,),
      onPressed: () {
        setState(() {
          showVideo = false;
        });
      },
              ),
            ],
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
                  onPressed: () =>
                      _showResponse('Какие эффекты сейчас в тренде?'),
                  child: Text(
                    'Какие эффекты сейчас в тренде?',
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
