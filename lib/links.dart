
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Links extends StatefulWidget {
  const Links({super.key});

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  @override
  Widget build(BuildContext context) {
  return Container(
  decoration: BoxDecoration(
    border: Border.all(width: 0.0, color: Colors.white),
    shape: BoxShape.circle,
  ),
  child: GestureDetector(
    onTap: () async {
      const url = 'https://t.me/'; // здесь укажите ссылку на ваш канал Telegram
      await launch(url);
    },
    child: Icon(Icons.telegram, color: Colors.white),
  ),
);
/*
Container(
  decoration: BoxDecoration(
    border: Border.all(width: 0.0, color: Colors.white),
    shape: BoxShape.circle,
  ),
  child: GestureDetector(
    onTap: () async {
      const url = 'https://vk.com/'; // здесь укажите ссылку на вашу страницу в VKontakte
      await launch(url);
    },
    child: Icon(Icons.vk, color: Colors.white),
  ),
),
*/
  }
}


