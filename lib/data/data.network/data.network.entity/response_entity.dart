import 'package:food/data/data.network/data.network.entity/gif_entity.dart';

class ResponseEntity{
  final List<GifEntity> data;

  ResponseEntity({required this.data});

  factory ResponseEntity.fromJson(Map<String, dynamic> json){
    final gifs = json['data'] as List <dynamic>;
    final List<GifEntity> entities = [];

    for (final gif in gifs){
      entities.add(GifEntity.fromJson(gif as Map<String, dynamic>));
    }

    return ResponseEntity(data: entities);
  }
}