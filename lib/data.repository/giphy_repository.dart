import 'package:food/data.network.client/giphy_client.dart';
import 'package:food/domain/gif.dart';

import '../data/data.network/data.network.entity/network_mapper.dart';

class GiphyRepository {
  final GiphyClient client;
  final NetworkMapper mapper;

  GiphyRepository({
    required this.client,
    required this.mapper,
  });

  Future<List<Gif>> getTrending({int? limit, int? offset}) async {
    final response = await client.getTrending(
      limit: limit,
      offset: offset,
    );
    return mapper.toGifs(response.data);
  }
}