import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/app_database.dart';

@UseRowClass(PlaylistWithSongEntity)
class PlaylistWithSongTable extends Table {
  IntColumn get id => integer()();
  IntColumn get songId => integer()();
  IntColumn get playlistId => integer()();

  ///Specifying which from the field above is the primary key
  @override
  Set<Column> get primaryKey => {id};
}

class PlaylistWithSongEntity {
  int? songId;
  int? playlistId;

  PlaylistWithSongEntity({this.songId, this.playlistId});

  PlaylistWithSongTableCompanion toCompanion() {
    return PlaylistWithSongTableCompanion(
      songId: Value(songId ?? -1),
      playlistId: Value(playlistId ?? -1),
    );
  }

  static Future<void> saveSinglePlaylistWithSongEntity(PlaylistWithSongEntity playlistWithSongEntity) async {
    AppDatabase db = AppDatabase();
    await db.into(db.playlistWithSongTable).insertOnConflictUpdate(playlistWithSongEntity.toCompanion());
  }

 static Future<List<PlaylistWithSongEntity>?> queryListOfPlaylistWithSongByPlaylistId(int playlistId) async {
    AppDatabase db = AppDatabase();
    List<PlaylistWithSongEntity> playlistWithSongEntityList = await (db.select(db.playlistWithSongTable)
      ..where((tbl) => tbl.playlistId.equals(playlistId)))
        .get();
    return playlistWithSongEntityList;
  }
}
