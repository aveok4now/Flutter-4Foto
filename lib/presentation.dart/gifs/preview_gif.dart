import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food/domain/gif.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail/detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class PreviewGif extends StatelessWidget {
  static const margin = 4.0;
  static const borderRadius = 4.0;

  final Gif gif;
  final bool isInLeft;
  final FavoriteChange? onFavoriteChange;

  const PreviewGif({
    required this.gif,
    required this.isInLeft,
    this.onFavoriteChange,
  });


Future<void> _shareGif() async {
    try {
      // Download gif
      final client = http.Client();
      final response = await client.get(Uri.parse(gif.url));
      client.close();

      // Store to temp directory
      final directory = await getTemporaryDirectory();
      final tempFile = File(
        '${directory.path}/${_encodeTitle(gif.title)}.gif',
      );
      await tempFile.writeAsBytes(response.bodyBytes);

      // Share the file
      await Share.shareFiles([tempFile.path]);
    } catch (_) {
      
    }
  }

  String _encodeTitle(String title) {
    return title.replaceAll(RegExp('[^A-Za-z0-9" "]'), '').replaceAll(' ', '_');
  }

  Future<void> _viewGif(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _downloadGif(
      String url, String filename, BuildContext context) async {
    Dio dio = Dio();

    try {
      var dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw Exception('Failed to get external storage directory.');
      }
      var filePath = '${dir.path}/$filename';
      var result = await dio.download(url, filePath);
      print('Download complete. $filePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Сохранено: $filePath'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Download error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: margin,
        top: margin,
        right: isInLeft ? 0.0 : margin,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Container(
                color: Colors.white,
                child: Column(
                  children: [
                    AppBar(
                      title: Text(
                        gif.title,
                        style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.gif_box_outlined,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            _viewGif(gif.url);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () {
                            print("tapped");
                            final filename = '${gif.id}.gif';
                            _downloadGif(gif.url, filename, context);
                          },
                        ),
                         IconButton(
                        icon: Icon(Icons.ios_share),
                        onPressed: () {
                          _shareGif();
                        },
                      ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: PhotoView(
                          imageProvider: NetworkImage(gif.url),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.network(gif.previewUrl),
          ),
        ),
      ),
    );
  }
}

class ShimmerPreviewGif extends StatelessWidget {
  final bool isInLeft;

  const ShimmerPreviewGif({required this.isInLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: PreviewGif.margin,
        top: PreviewGif.margin,
        right: isInLeft ? 0.0 : PreviewGif.margin,
      ),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.all(Radius.circular(PreviewGif.borderRadius)),
        child: Container(
          color: Colors.white,
          child: const Text(''),
        ),
      ),
    );
  }
}
