import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:food/hidden_drawer.dart';
import 'package:food/terms.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String _email = 'sevsuphotoeditor@gmail.com';
  final TextEditingController _messageController = TextEditingController();
 PageController _controller = PageController();
  bool onLastPage =false;

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
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => HiddenDrawer(),
          ),
        );
      },
    ),
  ),



  
      backgroundColor: Colors.deepPurple[300],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 18),
            Text(
              '4Editor создан для улучшения фотографий. Следите за тем, что сегодня предлагает искусственный интеллект, делитесь, сохраняйте и редактируйте изображения.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Спросите у чат-бота, что необходимо для создания крутых фотографий!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
              textAlign: TextAlign.justify,
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
                        hintText: 'Опишите проблему, с которой вы столкнулись',
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
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Политика конфиденциальности',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const TermsOfUsePage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Условия использования',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const TermsOfUsePage()));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
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
                        fontFamily: 'Raleway',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '4Editor v.1.0',
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
            ),
          ],
        ),
      ),
    );
  }
}
