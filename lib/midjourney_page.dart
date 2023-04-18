import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:midjourney_api/midjourney_api.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'image_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key});

  @override
  State<JourneyPage> createState() => _JourneyState();
}

class _JourneyState extends State<JourneyPage> {
  final controller = PageController();
  int currentIndex = 0;
  List<String> imageList = [];

  static const labelStyle = TextStyle(color: Colors.cyan);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            TopImages(),
            RecentImages(),
          ],
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              color: Colors.cyan,
            ),
            label: 'Лучшие',
            //backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time, color: Colors.cyan),
            label: 'Недавние',

            //backgroundColor: Colors.cyan,
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        activeColor: Colors.pink,
        inactiveColor: Colors.grey,
      ),
    );
  }
}

class TopImages extends StatefulWidget {
  const TopImages({Key? key});

  @override
  _TopImagesState createState() => _TopImagesState();
}

class _TopImagesState extends State<TopImages> {
  late List<String> _images = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final images = await MidJourneyApi().fetchTop();
    setState(() {
      _images = images;
      _loading = false;
    });
  }

  void _shuffleImages() {
    setState(() {
      _images.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showLoadingIndicator = _loading && _images.length < 4;
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 178, 246, 255),
          child: Column(
            children: [
              Expanded(
                child: showLoadingIndicator
                    ? Center(
                        child: SpinKitWave(
                          color: Colors.deepPurple,
                          size: 50.0,
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        children: _images.map((imageUrl) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                    imageUrls: _images,
                                    initialIndex: _images.indexOf(imageUrl),
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: imageUrl,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _shuffleImages,
            child: Icon(Icons.shuffle),
          ),
        ),
      ],
    );
  }
}

class RecentImages extends StatefulWidget {
  const RecentImages({Key? key});

  @override
  _RecentImagesState createState() => _RecentImagesState();
}

class _RecentImagesState extends State<RecentImages> {
  List<String> _images = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentImages();
  }

  Future<void> _fetchRecentImages() async {
    final images = await MidJourneyApi().fetchRecent();
    setState(() {
      _images = images;
      _loading = false;
    });
  }

  void _shuffleImages() {
    setState(() {
      _images.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showLoadingIndicator = _loading && _images.length < 4;
    return Stack(
      children: [
        Container(
          color: Color.fromARGB(255, 178, 246, 255),
          child: Column(
            children: [
              Expanded(
                child: showLoadingIndicator
                    ? Center(
                        child: SpinKitWave(
                          color: Colors.deepPurple,
                          size: 50.0,
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        children: _images.map((imageUrl) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                    imageUrls: _images,
                                    initialIndex: _images.indexOf(imageUrl),
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: imageUrl,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _shuffleImages,
            child: Icon(Icons.shuffle),
          ),
        ),
      ],
    );
  }
}

class ImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  var initialIndex;

  ImageViewer({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (imageUrls.isNotEmpty &&
              initialIndex >= 0 &&
              initialIndex < imageUrls.length)
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                try {
                  var response =
                      await http.get(Uri.parse(imageUrls[initialIndex]));
                  final bytes = response.bodyBytes;
                  final temp = await getTemporaryDirectory();
                  final timestamp = DateTime.now().millisecondsSinceEpoch;
                  final path = '${temp.path}/4Editor_AI_$timestamp.jpg';

                  File(path).writeAsBytesSync(bytes);

                  await Share.shareFiles([path]);
                } catch (e) {
                  print('Error sharing image: $e');
                }
              },
            ),
          if (imageUrls.isNotEmpty &&
              initialIndex >= 0 &&
              initialIndex < imageUrls.length)
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () async {
                try {
                  print(initialIndex);
                  var response =
                      await http.get(Uri.parse(imageUrls[initialIndex]));
                  final bytes = response.bodyBytes;

                  final temp = await getTemporaryDirectory();
                  final timestamp = DateTime.now().millisecondsSinceEpoch;
                  final fileName = imageUrls[initialIndex].split('/').last;
                  final path = '${temp.path}/$timestamp-$fileName';

                  File(path).writeAsBytesSync(bytes);
                  //await GallerySaver.saveImage(bytes as String, albumName: '4Editor');

                  final result =
                      await GallerySaver.saveImage(path, albumName: '4Editor');

                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Изображение успешно сохранено в галерею'), backgroundColor: Colors.green,),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка сохранения изображения')),
                    );
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Изображение успешно сохранено в галерею'), backgroundColor: Colors.green,),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка сохранения изображения')),
                  );
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: imageUrls.length,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imageUrls[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained * 0.5,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                onPageChanged: (index) {
                  initialIndex = index;
                  print("index");
                  print(index);
                  print("initialIndex");
                  print(initialIndex);
                },
                scrollPhysics: const BouncingScrollPhysics(),
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 143, 179),
                ),
                pageController: PageController(initialPage: initialIndex),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: CupertinoButton(
                  //padding: EdgeInsets.zero,
                  minSize: 40,
                  borderRadius: BorderRadius.all(Radius.circular(22.0)),
                  alignment: Alignment.center,
                  color: Colors.white,
                  onPressed: () async {
                    final currentContext = context;
                    var response =
                        await http.get(Uri.parse(imageUrls[initialIndex]));
                    final bytes = response.bodyBytes;
                    final temp = await getTemporaryDirectory();
                    final fileName = imageUrls[initialIndex].split('/').last;
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    final path = '${temp.path}/$timestamp-$fileName';
                    File file = File(path);
                    await file.writeAsBytes(bytes);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(
                          imagePath: path,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.purple[300],
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Редактировать фото',
                        style: TextStyle(
                          color: Colors.purple[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





/*class ImageViewer extends StatelessWidget {
  final String imageUrl;

  const ImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: imageUrl,
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}*/