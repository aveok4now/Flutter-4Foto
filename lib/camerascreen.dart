import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'camera.dart';
import 'hidden_drawer.dart';

class CameraScreen extends StatefulWidget {
  final File videoFile;

  CameraScreen({required this.videoFile});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Create a VideoPlayerController object and set the file to be played.
    _controller = VideoPlayerController.file(widget.videoFile)
      ..setLooping(true);

    // Initialize the controller and start playing the video automatically.
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    _isPlaying = true;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        actions: [
          Row(
            children: [
                IconButton(
                icon: Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HiddenDrawer(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.ios_share,
                ),
                onPressed: () async {
                  try {
                    final bytes = await widget.videoFile.readAsBytes();
                    final temp = await getTemporaryDirectory();
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    final path = '${temp.path}/4Foto_$timestamp.mp4';
                    File(path).writeAsBytesSync(bytes);
                    await Share.shareFiles([path]);
                  } catch (e) {
                    print('Error sharing image: $e');
                  }
                },
              ),
             
              IconButton(
                icon: Icon(
                  Icons.download,
                ),
                onPressed: () async {
                  try {
                    final tempDir = await getTemporaryDirectory();
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    final videoPath = '${tempDir.path}/4Foto_$timestamp.mp4';
                    await widget.videoFile.copy(videoPath);
                    final result = await GallerySaver.saveVideo(videoPath,
                        albumName: '4Foto');
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Видео успешно сохранено в галерею'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.up,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка сохранения видео'),
                        backgroundColor: Colors.transparent,
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        dismissDirection: DismissDirection.up,
                      ),
                    );
                  }
                },
              ),
             
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
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isPlaying) {
                            _controller.pause();
                            _isPlaying = false;
                          } else {
                            _controller.play();
                            _isPlaying = true;
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
