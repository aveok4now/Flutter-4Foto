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
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Если Вы столкнулись с какими-либо проблемами, пожалуйста, сообщите нам:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Опишите проблему, с которой Вы столкнулись',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendEmail,
              child: Text('Отправить'),
            ),
            Spacer(),
            Text(
              'Проект был выполнен в рамках конкурса "IT-Планета"',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text(
              '4Editor v.1.0.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
