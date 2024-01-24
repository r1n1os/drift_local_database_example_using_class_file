import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/app_database.dart';

@UseRowClass(PlaylistWithSongEntity)
class PlaylistWithSong extends Table {
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

  PlaylistWithSongCompanion toCompanion() {
    return PlaylistWithSongCompanion(
      songId: Value(songId ?? -1),
      playlistId: Value(playlistId ?? -1),
    );
  }

  static Future<void> saveSinglePlaylistWithSongEntity(
      PlaylistWithSongEntity playlistWithSongEntity) async {
    AppDatabase db = AppDatabase.instance();
    await db
        .into(db.playlistWithSong)
        .insertOnConflictUpdate(playlistWithSongEntity.toCompanion());
  }

  static Future<void> cleanRelationshipBasedOnPlaylistId(int playlistId) async {
    AppDatabase db = AppDatabase.instance();
    await (db.delete(db.playlistWithSong)
      ..where((tbl) => tbl.playlistId.equals(playlistId)))
        .go();
  }

  static Future<List<PlaylistWithSongEntity>?>
      queryListOfPlaylistWithSongByPlaylistId(int playlistId) async {
    AppDatabase db = AppDatabase.instance();
    List<PlaylistWithSongEntity> playlistWithSongEntityList =
        await (db.select(db.playlistWithSong)
              ..where((tbl) => tbl.playlistId.equals(playlistId)))
            .get();
    return playlistWithSongEntityList;
  }
}
