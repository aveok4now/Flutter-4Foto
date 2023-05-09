import 'package:flutter/material.dart';
import 'package:food/gif_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'detail/app_model.dart';

class GifApp extends StatelessWidget {
  final List<SingleChildWidget> providers;

  const GifApp({required this.providers});

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: providers,
      child: Consumer<AppModel> (builder: (BuildContext context, AppModel model, Widget? child) =>
      
      MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.white))
      ),
      themeMode: model.themeMode,
      home: MainScreen(),
      ),
      ),

    );
    
  }
}