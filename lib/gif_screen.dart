import 'package:flutter/material.dart';
import 'package:food/presentation.dart/gifs/detail/app_model.dart';
import 'package:food/presentation.dart/gifs/gifs_list.dart';
import 'package:food/util/design_utils.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget with DesignUtils{



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(''),
      actions: [
        IconButton(
          onPressed: () {
            final appModel = Provider.of<AppModel>(context, listen:false);

            if(isLight(context)){
              appModel.themeMode = ThemeMode.dark;
            }else{
              appModel.themeMode = ThemeMode.light;
            }
          },
          icon: Icon(
            
            isLight(context) ? Icons.dark_mode : Icons.light_mode)
        )
      ],

    ),
    body: const GifsList(),
  );
}
}