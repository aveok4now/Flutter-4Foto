import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class ImageScreen extends StatefulWidget {
  final String imagePath;

  const ImageScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  File? _croppedFile;
  int _selectedIndex = 0;
  bool _isImageChanged = false;
  bool _isUndoUsed = false;
  bool _isRedoUsed = false;

  
  
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
              toolbarColor: Color.fromARGB(255, 67, 117, 255),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
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
    if (_isUndoUsed) {
      _isRedoUsed = true;
    } else {
      _isRedoUsed = false;
    }
  });
}




void _onImageChanged(){
  setState(() {
    _isImageChanged = true;
    _isUndoUsed = false; 
    _isRedoUsed = false; 
  });
  _updateButtonsState();
}

void _undo() {
  _updateButtonsState(); 
  setState(() {
    _isUndoUsed = true; 
    _isRedoUsed = false;
  });
  _onImageChanged();
}

void _redo() {
  if (_isRedoUsed) {
    setState(() {
      _isUndoUsed = true;
      _isRedoUsed = false;
    });
    _onImageChanged();
  }
  _updateButtonsState();
}






  Future<void> _drawOnImage() async {}

  Future<void> _applyFilter() async {}

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
      onPressed: () => Navigator.of(context).pop(),
      ),
    
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Padding(
          padding : const EdgeInsets.only(right: 8.0),
          child: InkWell(
            onTap: _isImageChanged ? () {} : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.undo),
            ),
          ),
        
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: _isUndoUsed ? () {} : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.redo),
            ),
          ),

        ),
        Spacer(),
        Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: _isImageChanged ?  () {}: null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.save),
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
                icon: Icon(Icons.brush),
                label: 'Кисть',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_filter),
                label: 'Фильтры',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
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

  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        _cropImage();
        break;
      case 1:
        _drawOnImage();
        break;
      case 2:
        _applyFilter();
        break;
    }
  }
}
