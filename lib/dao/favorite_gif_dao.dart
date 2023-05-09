
import 'package:food/dao/base_dao.dart';
import 'package:food/entity/favorite_gif_entity.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteGifDao extends BaseDao {
  Future<List<FavoriteGifEntity>> selectAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query(BaseDao.favoritesTableName, orderBy: 'timestamp DESC');
    return List.generate(maps.length, (i) {
      return FavoriteGifEntity.fromMap(maps[i]);
    });
  }

  Future<FavoriteGifEntity?> selectById(String id) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      BaseDao.favoritesTableName,
      where: '${FavoriteGifEntity.fieldId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FavoriteGifEntity.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> insert(FavoriteGifEntity entity) async {
    final db = await getDatabase();
    await db.insert(
      BaseDao.favoritesTableName,
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await getDatabase();
    await db.delete(
      BaseDao.favoritesTableName,
      where: '${FavoriteGifEntity.fieldId} = ?',
      whereArgs: [id],
    );
  }
}