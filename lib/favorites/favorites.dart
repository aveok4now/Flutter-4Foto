import 'package:flutter/material.dart';
import 'package:food/data.repository/favorite_gif_repository.dart';
import 'package:food/domain/gif.dart';
import 'package:food/favorites/favorites_model.dart';
import 'package:food/presentation.dart/gifs/preview_gif.dart';
import 'package:food/util/values.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class Favorites extends StatelessWidget {
  const Favorites();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoritesModel>(
      create: (context) => FavoritesModel(
        Provider.of<Logger>(context, listen: false),
        Provider.of<FavoriteGifRepository>(context, listen: false),
      )..loadFavorites(),
      child: Consumer<FavoritesModel>(
        builder: (context, bloc, child) => StreamBuilder(
          stream: bloc.favoritesStream,
          builder: (BuildContext context, AsyncSnapshot<List<Gif>> snapshot) {
            if (snapshot.hasError) {
              return _getErrorLayout();
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return _getListLayout(bloc, snapshot.data!);
            } else if (snapshot.hasData) {
              return _getEmptyLayout();
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _getErrorLayout() {
    return Container(
      padding: const EdgeInsets.only(
        left: marginLat,
        top: marginVert,
        right: marginLat,
        bottom: marginVert,
      ),
      child: Center(
        //child: ErrorLayout(),
      ),
    );
  }

  Widget _getListLayout(FavoritesModel model, List<Gif> gifs) {
    final List<PreviewGif> previews = [];

    for (int i = 0; i < gifs.length; i++) {
      final gif = gifs[i];
      previews.add(
        PreviewGif(
          gif: gif,
          isInLeft: i.isOdd,
          onFavoriteChange: (bool isFavorite) {
            model.loadFavorites();
          },
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      children: previews,
    );
  }

  Widget _getEmptyLayout() {
    return Container(
      padding: const EdgeInsets.only(
        left: marginLat,
        top: marginVert,
        right: marginLat,
        bottom: marginVert,
      ),
      child: Center(
        child: _EmptyLayout(),
      ),
    );
  }
}

class _EmptyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          const Icon(
            Icons.favorite,
            size: sizeBigIcon,
          ),
          Padding(
            padding: const EdgeInsets.only(top: marginVertLarge),
            child: Text(
              "You haven't added any GIF to your favorites list yet!",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: marginVert),
            child: Text(
              'If you want to add a GIF to your favorites list, simply click on it in the general list to enter its details. On the top bar you will see a heart icon, you can tap that icon to add that GIF to your favorites list and tap it again to remove it.',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}