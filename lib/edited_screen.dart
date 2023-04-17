import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'main.dart';

class EditedImageScreen extends StatefulWidget {
  final File imageFile;

  const EditedImageScreen({Key? key, required this.imageFile})
      : super(key: key);

  @override
  _EditedImageScreenState createState() => _EditedImageScreenState();
}

class _EditedImageScreenState extends State<EditedImageScreen> {
  bool _hasVisitedEditedImageScreen = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          Navigator.of(context).pop();
        }
      },
      
     

      child: Tooltip(
        message: "Свайпните вправо, чтобы вернуться",
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade800,
                  Colors.pink.shade300,
                ],
              ),
            ),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.pink.shade50,
                          width: 4.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: InteractiveViewer(
                        child: Image.file(
                          widget.imageFile,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
         
                Padding(
                  
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Row(
                          children: [
                            Icon(Icons.share, color: Colors.white),
                            SizedBox(width: 4.0),
                            Text("Поделиться",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        onPressed: () async {
                          try {
                            final bytes = await widget.imageFile.readAsBytes();
                            final temp = await getTemporaryDirectory();
                            final timestamp =
                                DateTime.now().millisecondsSinceEpoch;
                            final path =
                                '${temp.path}/4Editor_AI_$timestamp.jpg';
                            File(path).writeAsBytesSync(bytes);
                            await Share.shareFiles([path]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Изображение успешно сохранено в галерею'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            print('Error sharing image: $e');
                          }
                        },
                      ),
                      CupertinoButton(
                        child: Row(
                          children: [
                            Icon(Icons.download, color: Colors.white),
                            SizedBox(width: 4.0),
                            Text("Сохранить",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        onPressed: () async {
                          try {
                            final bytes = await widget.imageFile.readAsBytes();
                            final temp = await getDownloadsDirectory();
                            final timestamp =
                                DateTime.now().millisecondsSinceEpoch;
                            final path =
                                '${temp?.path}/4Editor_AI_$timestamp.jpg';
                            File(path).writeAsBytesSync(bytes);
                          } catch (e) {
                            print('Error saving image: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            actions: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditorScreen(),
                        ),
                        
                      );
                    },
                    
                  ),
                  
                ],
              ),
              
            ],
          ),
          
        ),
        
      ),
      
    );
  }
}
