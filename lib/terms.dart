import 'package:flutter/material.dart';
import 'package:food/hidden_drawer.dart';
import 'package:food/settings_page.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Условия использования', textAlign: TextAlign.center,),
        centerTitle: true,
        leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) => const SettingsPage(),
  )).then((_) {
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
                '1.1 Данное приложение предназначено только для персонального использования. Запрещено использование его в коммерческих целях.', style: TextStyle(fontSize: 16, wordSpacing: 1), textAlign: TextAlign.justify,
                
              ),
              const SizedBox(height: 8),
              const Text(
                '1.2 Пользователь несет ответственность за любые материалы, загруженные в приложение.', style: TextStyle(fontSize: 16, wordSpacing: 1), textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                '1.3 Приложение не гарантирует точность результатов, полученных в процессе работы.', style: TextStyle(fontSize: 16, wordSpacing: 1), textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                '1.4 Приложение может временно не работать или работать некорректно из-за технических проблем. Мы не несем ответственности за любые потери, связанные с использованием приложения.', style: TextStyle(fontSize: 16, wordSpacing: 1), textAlign: TextAlign.justify, 
              ),
              const SizedBox(height: 8),
              const Text(
                '1.5 Приложение может содержать ссылки на сторонние сайты, мы не несем ответственности за содержимое этих сайтов.', style: TextStyle(fontSize: 16, wordSpacing: 1), textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
