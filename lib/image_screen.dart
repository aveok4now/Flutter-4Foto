import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_photo_editor/flutter_photo_editor.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as imageLib;
//import 'filters.dart';
import 'dart:async';
import 'package:text_editor/text_editor.dart';
import 'package:vibration/vibration.dart';
import 'edited_screen.dart';
import 'package:image/image.dart' as img;


class ImageScreen extends StatefulWidget {
  final String imagePath;

  //const ImageScreen({Key? key, required this.imagePath, required File imageFile}) : super(key: key);
  const ImageScreen({Key? key, required this.imagePath}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  File? _croppedFile;
  File? _originalImage;
  int _selectedIndex = 0;
  bool _isImageChanged = false;
  bool _isUndoUsed = false;
  bool _isRedoUsed = false;
  List<File> _imageStack = [];
  List<File> _redoStack = [];
  double undoOpacity = 0.5;
  double redoOpacity = 0.5;
  double saveOpacity = 0.5;
  bool _hasVisitedEditedImageScreen = false;

  void _navigateToEditedImageScreen() async {
    final bool? hasVisitedEditedImageScreen = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditedImageScreen(
          imageFile: _croppedFile!,
        ),
      ),
    );
    if (hasVisitedEditedImageScreen == true) {
      setState(() {
        _hasVisitedEditedImageScreen = true;
      });
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _originalImage = File(widget.imagePath);
    _imageStack.add(_originalImage!);
  }

  Future<void> _cropImage() async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _croppedFile?.path ?? widget.imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: '',
              toolbarColor: Colors.cyan,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              activeControlsWidgetColor: Colors.cyan),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = File(croppedFile.path);
          _onImageChanged();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _updateButtonsState() {
    setState(() {
      if (_imageStack.isNotEmpty) {
        _isUndoUsed = true;
        undoOpacity = 1.0;
      } else {
        _isUndoUsed = false;
        undoOpacity = 0.5;
      }

      if (_redoStack.isNotEmpty) {
        _isRedoUsed = true;
        redoOpacity = 1.0;
      } else {
        _isRedoUsed = false;
        redoOpacity = 0.5;
      }
    });
  }

  void _onDonePressed() async {
    if (_croppedFile != null) {
      if (_hasVisitedEditedImageScreen) {
        Navigator.pop(context);
      } else {
        final editedImageFile = await _getEditedImage();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditedImageScreen(
              imageFile: editedImageFile,
            ),
          ),
        );
      }
    }
  }

  Future<File> _getEditedImage() async {
    return _croppedFile!;
  }

  void _onImageChanged() {
    setState(() {
      _isImageChanged = true;
      saveOpacity = 1.0;
      _imageStack.add(_croppedFile!);
      _redoStack.clear();
    });
    _updateButtonsState();
  }

  void _undo() {
    if (_imageStack.isNotEmpty) {
      _redoStack.add(_imageStack.removeLast());
      setState(() {
        _croppedFile = _imageStack.isNotEmpty ? _imageStack.last : null;
        _isImageChanged = true;
      });
      _updateButtonsState();
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _croppedFile = _redoStack.removeLast();
        _imageStack.add(_croppedFile!);
        _isImageChanged = true;
      });
      _updateButtonsState();
    }
  }

  Future<void> _applyFilter() async {
    //final List<Filter> filters = presetFiltersList;
  }
   //   );
     // if (result != null && result.containsKey('image_filtered')) {
     //   setState(() {
      //    _croppedFile = File(result['image_filtered']);
     //     _onImageChanged();
    //    });
   //   }
  //  }
//  }

  Widget _buildImage() {
    final imagePath = _croppedFile?.path ?? widget.imagePath;

    return Transform.scale(
      scale: _scale,
      child: Image.file(
        File(imagePath),
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Vibration.vibrate(duration: 40, amplitude: 9);
             Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: _isUndoUsed ? _undo : null,
                child: Opacity(
                  opacity: undoOpacity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.undo),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: InkWell(
                onTap: _isRedoUsed ? _redo : null,
                child: Opacity(
                  opacity: redoOpacity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.redo),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: InkWell(
                onTap: _isImageChanged ? _onDonePressed : null,
                child: Opacity(
                  opacity: undoOpacity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.done),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onScaleStart: (details) {
              _previousScale = _scale;
              setState(() {});
            },
            onScaleUpdate: (details) {
              _scale = _previousScale * details.scale;
              setState(() {});
            },
            onDoubleTap: () {
              _scale = _scale == 1.0 ? 2.0 : 1.0;
              setState(() {});
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 9, 248, 236),
                    Color.fromARGB(31, 81, 105, 182)
                  ],
                ),
              ),
              child: Center(
                child: _buildImage(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CupertinoTabBar(
              backgroundColor: Colors.transparent,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.crop),
                  label: 'Обрезка',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_fields),
                  label: 'Текст',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.brush_outlined),
                  label: 'Кисть',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_filter),
                  label: 'Фильтры',
                ),

              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                Vibration.vibrate(duration: 40, amplitude: 9);
                setState(() {
                  _selectedIndex = index;
                });
                _onTabTapped(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _editedText = '';
  Widget _buildTextEditor() {
    final imageWidget = _croppedFile != null
        ? Image.file(_croppedFile!)
        : Image.file(_originalImage!);
    String _text = "";
    double scale = 1.0; // начальный масштаб

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0d47a1),
                Color(0xff1e88e5),
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onScaleUpdate: (details) {
                    setState(() {
                      scale = details.scale;
                    });
                  },
                  child: Transform.scale(
                    scale: scale,
                    child: imageWidget,
                  ),
                ),
              ),
              Center(
                child: TextEditor(
                  paletteColors: [
                    Colors.black,
                    Colors.white,
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.yellow,
                    Colors.pink,
                    Colors.cyanAccent,
                  ],
                  fonts: [
                    'OpenSans',
                    'Billabong',
                    'GrandHotel',
                    'Oswald',
                    'Quicksand',
                    'BeautifulPeople',
                    'BeautyMountains',
                    'BiteChocolate',
                    'BlackberryJam',
                    'BunchBlossoms',
                    'CinderelaRegular',
                    'Countryside',
                    'Halimun',
                    'LemonJelly',
                    'QuiteMagicalRegular',
                    'Tomatoes',
                    'TropicalAsianDemoRegular',
                    'VeganStyle',
                  ],
                  onEditCompleted: (style, align, text) async {
                    setState(() {
                      _text = text;
                    });
                    Navigator.of(context).pop(_text);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void addTextToImage(File imageFile, String text) {

  final bytes = imageFile.readAsBytesSync();
  final image = img.decodeImage(bytes);


  final font = img.arial_24;
  final color = img.getColor(255, 255, 255);
  img.drawString(image!, font, 0, 0, text, color: color);


  final newFile = File('${imageFile.path}_with_text.jpg');
  newFile.writeAsBytesSync(img.encodeJpg(image));
}

  Future<void> _onTabTapped(int index) async {
    switch (index) {
      case 0:
        _cropImage();
        break;
      case 1:
  final text = await Navigator.of(context).push<String>(
    MaterialPageRoute(builder: (context) => _buildTextEditor()),
  );
  if (text != null) {
    setState(() {
      _editedText = text;
    });
    if (_croppedFile != null) {
      addTextToImage(_croppedFile!, _editedText);
    } else if (_originalImage != null) {
      addTextToImage(_originalImage!, _editedText);
    }
  }
  break;
      case 3:
        _applyFilter();
        break;
        case 2:
        _draw();
        break;
    }
    
  }
  
 void _draw() async{
  bool isSuccess = await FlutterPhotoEditor().editImage(widget.imagePath);
  String editedImagePath = isSuccess ? widget.imagePath : "";
  
  // сохраняем отредактированное изображение с тем же именем и путь к нему, как у исходного изображения
  await File(editedImagePath).copy(widget.imagePath);
  //_onImageChanged();
}

}
