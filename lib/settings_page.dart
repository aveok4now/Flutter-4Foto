import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String _email = 'sevsuphotoeditor@gmail.com';
  final TextEditingController _messageController = TextEditingController();

  void _sendEmail() async {
    final Email email = Email(
      body: _messageController.text,
      subject: 'Проблема с приложением 4Editor',
      recipients: [_email],
    );

    await FlutterEmailSender.send(email);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.deepPurple[300],
    body: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Text(
            'Если Вы столкнулись с какими-либо проблемами, пожалуйста, сообщите нам:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              //fontFamily: 'Ubuntu',
            ),
            //textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Опишите проблему, с которой Вы столкнулись',
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(height: 16),
                CupertinoButton.filled(
                  onPressed: _sendEmail,
                  child: Text('Отправить'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Container(
            height: 80,
            child: Column(
              children: [
                Spacer(),
                Text(
                  'Проект был выполнен в рамках конкурса "IT-Планета"',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Ubuntu',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  '4Editor v.1.0.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    ),
  );
}
}
