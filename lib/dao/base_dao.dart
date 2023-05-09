import 'package:food/entity/favorite_gif_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao {
  static const databaseName = 'com.example.fluttergifapp/database.db';

  static const favoritesTableName = 'favorites';

  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        final batch = db.batch();
        _createFavoritesTableV1(batch);
        await batch.commit();
      },
      version: 1,
    );
  }

  void _createFavoritesTableV1(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE $favoritesTableName(
        ${FavoriteGifEntity.fieldId} TEXT PRIMARY KEY NOT NULL,
        ${FavoriteGifEntity.fieldTitle} TEXT NOT NULL,
        ${FavoriteGifEntity.fieldPreviewUrl} TEXT NOT NULL,
        ${FavoriteGifEntity.fieldUrl} TEXT NOT NULL,
        ${FavoriteGifEntity.fieldTimestamp} INTEGER NOT NULL,
        ${FavoriteGifEntity.fieldDisplayName} TEXT NULL,
        ${FavoriteGifEntity.fieldUsername} TEXT NULL,
        ${FavoriteGifEntity.fieldUserProfileUrl} TEXT NULL
      );
      ''',
    );
  }
}