import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:food/hidden_drawer.dart';
import 'package:food/politics.dart';
import 'package:food/terms.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vibration/vibration.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String _email = 'sevsuphotoeditor@gmail.com';
  final TextEditingController _messageController = TextEditingController();
  PageController _controller = PageController();
  bool onLastPage = false;

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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Vibration.vibrate(duration: 50, amplitude: 18);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => HiddenDrawer(),
                ),
              );
            },
          ),
        ),
        backgroundColor: Colors.deepPurple[300],
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Expanded(
            child: Column(
              children: [
                SizedBox(height: 18),
                Text(
                  '4Foto создан для улучшения фотографий. Следите за тем, что сегодня предлагает искусственный интеллект, делитесь, сохраняйте и редактируйте изображения.',
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText:
                                'Опишите проблему, с которой вы столкнулись',
                          ),
                          maxLines: null,
                        ),
                        SizedBox(height: 16),
                        CupertinoButton.filled(
                          onPressed: () {
                            Vibration.vibrate(duration: 50, amplitude: 18);
                            _sendEmail();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Спасибо, что помогаете нам стать лучше!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.up,
                              ),
                            );
                          },
                          child: Text('Отправить'),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(
                            Icons.description_outlined,
                            color: Colors.white,
                          ),
                          title: const Text('Политика конфиденциальности',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Vibration.vibrate(duration: 40, amplitude: 10);
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const TermsOfUsePage()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.description_outlined,
                            color: Colors.white,
                          ),
                          title: const Text('Условия использования',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Vibration.vibrate(duration: 50, amplitude: 18);
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const PoliticsPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80,
                      color: Colors.transparent,
                      child: Column(
                        children: [
                         // const Spacer(),
                          const Text(
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
                            '4Foto v.1.0',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
