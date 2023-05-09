import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food/data.repository/favorite_gif_repository.dart';
import 'package:food/presentation.dart/gifs/detail/detail_model.dart';
import 'package:food/util/values.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


import 'package:provider/provider.dart';
import 'package:food/domain/gif.dart';
import 'package:food/util/design_utils.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

typedef FavoriteChange = Function(bool isFavorite);

class DetailScreen extends StatefulWidget {
  final Gif gif;
  final FavoriteChange? onFavoriteChange;

  const DetailScreen({super.key, 
    required this.gif,
    this.onFavoriteChange,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with DesignUtils {
  static const _snackbarDuration = 2;

  late final DetailModel _model;

  late final Future _future;

  @override
  void initState() {
    super.initState();

    _model = DetailModel(
      Provider.of<FavoriteGifRepository>(context, listen: false),
      widget.gif,
    );

    _future = _model.checkFavorite();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) => ChangeNotifierProvider.value(
        value: _model,
        child: Consumer<DetailModel>(
          builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: const Text('GIF'),
              actions: kIsWeb
                  ? null
                  : [
                      IconButton(
                        onPressed: () => model.isFavorite
                            ? _removeFromFavorites()
                            : _addToFavorites(),
                        tooltip: model.isFavorite
                            ? 'Remove favorite'
                            : 'Add to favorites',
                        icon: Icon(
                          model.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: _shareGif,
                        tooltip: 'Share',
                        icon: Icon(
                          isCupertino(context)
                              ? CupertinoIcons.share
                              : Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ],
            ),
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: marginLat,
                    top: 30.0,
                    right: marginLat,
                    bottom: 30.0,
                  ),
                  child: Text(
                    widget.gif.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _Gif(
                  gif: widget.gif,
                ),
                if (widget.gif.displayName != null)
                  Container(
                    padding: const EdgeInsets.only(
                      left: marginLat,
                      right: marginLat,
                    ),
                    child: _CreatedBy(
                      name: widget.gif.displayName!,
                      profileUrl: widget.gif.userProfileUrl,
                    ),
                  )
                else
                  Container(),
                Container(
                  padding: const EdgeInsets.only(
                    left: marginLat,
                    top: marginVertLarge,
                    right: marginLat,
                    bottom: marginVert,
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 20.0,
                      width: double.infinity,
                      child: Image.asset(
                        isLight(context)
                            ? 'assets/img_giphy_light.png'
                            : 'assets/img_giphy_dark.png',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareGif() async {
    try {
      // Download gif
      final client = http.Client();
      final response = await client.get(Uri.parse(widget.gif.url));
      client.close();

      // Store to temp directory
      final directory = await getTemporaryDirectory();
      final tempFile = File(
        '${directory.path}/${_encodeTitle(widget.gif.title)}.gif',
      );
      await tempFile.writeAsBytes(response.bodyBytes);

      // Share the file
      await Share.shareFiles([tempFile.path]);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong, please contact support if the problem persists.',
          ),
        ),
      );
    }
  }

  String _encodeTitle(String title) {
    return title.replaceAll(RegExp('[^A-Za-z0-9" "]'), '').replaceAll(' ', '_');
  }

  Future<void> _addToFavorites() async {
    String message;
    try {
      await _model.addToFavorites();
      widget.onFavoriteChange?.call(true);
      if (!mounted) return;
      message = 'This GIF has been added to your favorites list.';
    } catch (_) {
      message =
          'Something went wrong, please contact support if the problem persists.';
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: _snackbarDuration),
      ),
    );
  }

  Future<void> _removeFromFavorites() async {
    String message;
    try {
      await _model.removeFromFavorites();
      widget.onFavoriteChange?.call(false);
      if (!mounted) return;
      message = 'This GIF has been removed from your favorites list.';
    } catch (_) {
      message =
          'Something went wrong, please contact support if the problem persists.';
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: _snackbarDuration),
      ),
    );
  }
}

class _Gif extends StatelessWidget with DesignUtils {
  static const _size = 300.0;

  final Gif gif;

  const _Gif({required this.gif});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: marginLat,
        top: marginVert,
        right: marginLat,
        bottom: marginVert,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(stdBorderRadius)),
        child: Image.network(
          gif.url,
          loadingBuilder: (context, widget, loadingProgress) {
            if (loadingProgress == null) {
              return widget;
            } else {
              return Shimmer.fromColors(
                baseColor:
                    isLight(context) ? shimmerBaseColor : shimmerBaseColorDark,
                highlightColor: isLight(context)
                    ? shimmerHighlightColor
                    : shimmerHightlightColorDark,
                child: SizedBox(
                  width: _size,
                  height: _size,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _CreatedBy extends StatelessWidget {
  static const _maxNameLength = 22;

  final String name;
  final String? profileUrl;

  const _CreatedBy({required this.name, this.profileUrl});

  @override
  Widget build(BuildContext context) {
    String finalName = name;
    if (finalName.length > _maxNameLength) {
      finalName = '${name.substring(0, _maxNameLength - 3)}...';
    }

    Widget usernameWidget;
    if (profileUrl != null) {
      final uri = Uri.parse(profileUrl!);

      usernameWidget = TextButton(
        child: Text(finalName),
        onPressed: () async {
          if (await canLaunchUrl(uri)) {
            launchUrl(uri);
          }
        },
      );
    } else {
      usernameWidget = Text(finalName);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Created by:'),
        usernameWidget,
      ],
    );
  }
}