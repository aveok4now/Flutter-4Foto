import 'package:food/data/data.network/data.network.entity/gif_entity.dart';
import 'package:food/data/data.network/data.network.entity/rendition_entity.dart';
import 'package:food/domain/gif.dart';

import 'images_entity.dart';

class MapperException<From, To> implements Exception {
  final String message;

  MapperException(this.message);

  @override
  String toString() {
    return 'Error when mapping class $From to $To: $message}';
  }
}

class NetworkMapper {
  Gif? toGif(GifEntity entity) {
    try {
      final previewRendition = _getPreviewRendition(entity.images);
      if (previewRendition == null) return null;
      final rendition = entity.images.original;
      if (!_isRenditionUsable(entity.images.original)) return null;

      return Gif(
        id: entity.id,
        title: entity.title,
        previewUrl: previewRendition.url!,
        url: rendition.url!,
        displayName: entity.user?.displayName,
        username: entity.user?.username,
        userProfileUrl: entity.user?.profileUrl,
      );
    } catch (e) {
      throw MapperException<GifEntity, Gif>(e.toString());
    }
  }

  List<Gif> toGifs(List<GifEntity> entities) {
    final List<Gif> models = [];

    for (final entity in entities) {
      final model = toGif(entity);
      if (model != null) {
        models.add(model);
      }
    }

    return models;
  }

  RenditionEntity? _getPreviewRendition(ImagesEntity images) {
    if (_isRenditionUsable(images.previewGif)) {
      return images.previewGif;
    } else if (_isRenditionUsable(images.original)) {
      return images.original;
    } else {
      return null;
    }
  }

  bool _isRenditionUsable(RenditionEntity rendition) {
    return rendition.url != null &&
        rendition.url!.isNotEmpty &&
        rendition.width != null &&
        rendition.width!.isNotEmpty &&
        rendition.height != null &&
        rendition.width!.isNotEmpty;
  }
}