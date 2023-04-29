import 'package:flutter/material.dart';
import 'package:food/hidden_drawer.dart';
import 'package:food/settings_page.dart';
import 'package:vibration/vibration.dart';

class PoliticsPage extends StatefulWidget {
  const PoliticsPage({Key? key}) : super(key: key);

  @override
  State<PoliticsPage> createState() => _PoliticsPageState();
}

class _PoliticsPageState extends State<PoliticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Политика конфиденциальности',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Vibration.vibrate(duration: 50, amplitude: 18);
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const SettingsPage(),
            ))
                .then((_) {
              Navigator.of(context).pop();
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Общие положения',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '1.1 Приложение не собирает личную информацию пользователя.',
                style: TextStyle(fontSize: 16, wordSpacing: 1),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                '1.2 Мы не передаем информацию о пользователях третьим лицам.',
                style: TextStyle(fontSize: 16, wordSpacing: 1),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                '1.3 Приложение может использовать файлы cookie для сохранения настроек пользователя, однако эти файлы не содержат личной информации.',
                style: TextStyle(fontSize: 16, wordSpacing: 1),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                '1.4 Мы можем использовать данные, собранные в процессе работы приложения, для улучшения его функциональности и качества.',
                style: TextStyle(fontSize: 16, wordSpacing: 1),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                '1.5 Если вы не согласны с данной политикой конфиденциальности, пожалуйста, прекратите использование приложения.',
                style: TextStyle(fontSize: 16, wordSpacing: 1),
                textAlign: TextAlign.justify,
              ),
              const Text(
                'Если у Вас возникли вопросы, Вы можете связаться связаться с нами по адресу: sevsuphotoeditor@gmail.com. Или отправьте сообщение в форме об ошибках в приложении.',
                style: TextStyle(fontSize: 16, wordSpacing: 1),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
