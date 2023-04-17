import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(ChatbotApp());

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
  };

  void _showResponse(String question) {
    String response =
        _responses[question] ?? 'Извините, я не понял ваш вопрос.';
    setState(() {
      _chatMessages.add('Вы: $question');
      _chatMessages.add('Чат-бот: $response');
      _controller.clear();
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                reverse: true,
                itemCount: _chatMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  final String message = _chatMessages[index];
                  return ListTile(
                    leading: message.startsWith('Вы')
                        ? Icon(Icons.account_circle)
                        : Icon(Icons.android),
                    title: Text(message),
                  );
                },
              ),
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
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                CupertinoButton(
                  onPressed: () => _showResponse('Как делать хорошие фото?'),
                  child: Text('Как делать хорошие фото?'),
                ),
                CupertinoButton(
                  onPressed: () => _showResponse(
                      'В какое время суток делать фото лучше всего?'),
                  child: Text('В какое время суток делать фото лучше всего?'),
                ),
                CupertinoButton(
                  onPressed: () =>
                      _showResponse('Какие эффекты сейчас в тренде?'),
                  child: Text('Какие эффекты сейчас в тренде?'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
