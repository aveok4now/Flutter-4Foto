import 'package:flutter/material.dart';
import 'package:food/data.repository/giphy_repository.dart';
import 'package:food/domain/gif.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GifsListModel {
  static const limit = 25000;

  late final Logger log;
  late final GiphyRepository giphyRepo;

  GifsListModel(BuildContext context) {
    log = Provider.of<Logger>(context, listen: false);
    giphyRepo = Provider.of<GiphyRepository>(context, listen: false);
  }

  Future<List<Gif>> fetchGifs(int offset) async {
    try {

      return await giphyRepo.getTrending(
        offset: offset,
        limit: limit,
      );
    } catch (e) {
      log.e('Error while testing trending: $e');
      rethrow;
    }
  }
}