import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/song_entity.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/playlist_with_song_entity.dart';

import '../app_database.dart';

@UseRowClass(PlaylistEntity)
class PlaylistTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get numberOfSongs => integer()();
  IntColumn get userId => integer()();

  ///Specifying which from the field above is the primary key
  @override
  Set<Column> get primaryKey => {id};
}

class PlaylistEntity {
  int? id;
  String? name;
  int? numberOfSongs;
  int? userId;
  List<SongEntity>? songEntityList;

  PlaylistEntity(
      {this.id,
      this.name,
      this.numberOfSongs,
      this.userId,
      this.songEntityList});

  PlaylistTableCompanion toCompanion() {
    return PlaylistTableCompanion(
      id: Value(id ?? -1),
      name: Value(name ?? ''),
      numberOfSongs: Value(numberOfSongs ?? 0),
      userId: Value(userId ?? -1),
    );
  }

  static Future<void> saveSinglePlaylistEntity(
      PlaylistEntity playlistEntity) async {
    AppDatabase db = AppDatabase();
    await db
        .into(db.playlistTable)
        .insertOnConflictUpdate(playlistEntity.toCompanion());
    if (playlistEntity.songEntityList != null) {
      await _saveSongAndRelationshipData(
          playlistEntity.songEntityList ?? [], playlistEntity.id ?? -1);
    }
  }

  static Future<void> _saveSongAndRelationshipData(
      List<SongEntity> songEntityList, int playlistId) async {
    await Future.forEach(songEntityList, (songEntity) async {
      SongEntity.saveSingleSongEntity(songEntity);
      await PlaylistWithSongEntity.saveSinglePlaylistWithSongEntity(
          PlaylistWithSongEntity(
              songId: songEntity.id, playlistId: playlistId));
    });
  }

  static Future<void> saveListOfPlaylist(
      List<PlaylistEntity> playlistEntityList) async {
    await Future.forEach(playlistEntityList, (playlistEntity) {
      saveSinglePlaylistEntity(playlistEntity);
    });
  }

  static Future<List<PlaylistEntity>> queryAllPlaylists() async {
    AppDatabase db = AppDatabase();
    List<PlaylistEntity> playlistEntityList = await db.select(db.playlistTable).get();
    return playlistEntityList;
  }

  static Future<PlaylistEntity?> queryPlaylistById(int playlistId) async {
    AppDatabase db = AppDatabase();
    PlaylistEntity? playlistEntity = await (db.select(db.playlistTable)
          ..where((tbl) => tbl.id.equals(playlistId)))
        .getSingleOrNull();
    return playlistEntity;
  }

  static Future<PlaylistEntity?> queryPlaylistByUserId(int userId) async {
    AppDatabase db = AppDatabase();
    PlaylistEntity? playlistEntity = await (db.select(db.playlistTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .getSingleOrNull();
    return playlistEntity;
  }
}
