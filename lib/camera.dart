import 'dart:io';

import 'package:camera_filters/camera_filters.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'camerascreen.dart';
import 'edited_screen.dart';



class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
late File _imageFile;
late File _videoFile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CameraScreenPlugin(onDone: (value) {
          /// value returns the picture path you can save here or navigate to some screen
          /// 
          setState(() {
            _imageFile = File(value);
          });
           Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditedImageScreen(
              imageFile: _imageFile,
            ),
          ),
        );
          print(value);
        },

            /// value returns the video path you can save here or navigate to some screen
            onVideoDone: (value) async {
              setState(() {
              _videoFile = File(value);
            });
          print(value);
          final directory = await getApplicationDocumentsDirectory();
            final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
            final newPath = '${directory.path}/$fileName';
            final newFile = await _videoFile.copy(newPath);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraScreen(
                  videoFile: newFile,
                ),
              ),
            );
        },
         filters: [
         Colors.transparent, 
         Colors.blue, 
         Colors.blueAccent, 
         Colors.purple, 
         Colors.deepPurple, 
         Colors.deepPurpleAccent, 
         Colors.deepOrange,
         Colors.orange, 
         Colors.orangeAccent, 
         Colors.yellow,
         Colors.green, 
         Colors.cyan, 
         Colors.black, 
         Colors.white, 
         Colors.red,
         Colors.indigo,
         Colors.lime,
         Colors.pink,
         Colors.teal,
         ],
            /// profileIconWidget: , if you want to add profile icon on camera you can your widget here
            /// 
          // profileIconWidget: Icon(Icons.camera_alt_rounded, color: Colors.deepPurple,),
            ///filterColor: ValueNotifier<Color>(Colors.transparent),  your first filter color when you open camera

            /// filters: [],
            ///you can pass your own list of colors like this List<Color> colors = [Colors.blue, Colors.blue, Colors.blue ..... Colors.blue]
            ///make sure to pass transparent color to first index so the first index of list has no filter effect
            ),
      ),
    );
  }
}