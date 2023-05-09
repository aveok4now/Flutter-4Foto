

import 'package:food/domain/gif.dart';

import '../dao/favorite_gif_dao.dart';
import '../entity/database_mapper.dart';

class FavoriteGifRepository {
  final FavoriteGifDao dao;
  final DatabaseMapper mapper;

  FavoriteGifRepository({
    required this.dao,
    required this.mapper,
  });

  Future<List<Gif>> selectAll() async {
    final entities = await dao.selectAll();
    return mapper.toGifs(entities);
  }

  Future<Gif?> selectById(String id) async {
    final entity = await dao.selectById(id);
    if (entity != null) {
      return mapper.toGif(entity);
    } else {
      return null;
    }
  }

  Future<void> insert(Gif gif) async {
    final favoriteGif = mapper.toFavoriteGif(gif);
    await dao.insert(favoriteGif);
  }

  Future<void> delete(String id) async {
    await dao.delete(id);
  }
}