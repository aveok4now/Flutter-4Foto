import 'dart:convert';

import 'package:food/data.network.client/base_client.dart';
import 'package:food/data/data.network/data.network.entity/response_entity.dart';
import 'package:logger/logger.dart';

class GiphyClient extends BaseClient{
  final String baseUrl;
  final String apiKey;

  GiphyClient({
    required this.baseUrl,
    required this.apiKey,
    required Logger log,
  }) : super(log: log);

  Future<ResponseEntity> getTrending({int? limit, int? offset}) async {
    final params = {
      'api_key' : apiKey,
    };

    if (limit != null){
      params['limit'] = limit.toString();
    }

    if(offset != null){
      params['offset'] = offset.toString();
    }

//ссылка на гиф
//TODO: ADD AI GIFS
    final response = await get('${baseUrl}v1/gifs/search?api_key=kt937MBbd0y0nd3baToK6qdSw07NEg3e&q=ai&limit=25000&offset=5&rating=g&lang=en', queryParameters: params);

    checkKo(response, 'get_trending', body: params.toString());
    
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ResponseEntity.fromJson(json);
  }
}