import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/app_database.dart';

@UseRowClass(SongEntity)
class SongTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get duration => integer()();
  IntColumn get artistId => integer()();

  ///Specifying which from the field above is the primary key
  @override
  Set<Column> get primaryKey => {id};
}

class SongEntity {
  int? id;
  String? name;
  int? duration;
  int? artistId;

  SongEntity({this.id, this.name, this.duration, this.artistId});

  SongTableCompanion toCompanion() {
    return SongTableCompanion(
        id: Value(id ?? -1),
        name: Value(name ?? ''),
        duration: Value(duration ?? 0),
        artistId: Value(artistId ?? 0)
    );
  }

  static Future<void> saveSingleSongEntity(SongEntity songEntity) async {
    AppDatabase db = AppDatabase();
    await db.into(db.songTable).insertOnConflictUpdate(songEntity.toCompanion());
  }

  static Future<void> saveListOfSongsEntity(
      List<SongEntity> songEntityList) async {
    await Future.forEach(songEntityList, (songEntity) {
      saveSingleSongEntity(songEntity);
    });
  }

  static Future<List<SongEntity>> queryAllSongs() async {
    AppDatabase db = AppDatabase();
    List<SongEntity> songEntityList = await db.select(db.songTable).get();
    return songEntityList;
  }

  static Future<SongEntity?> querySongById(int songId) async {
    AppDatabase db = AppDatabase();
    SongEntity? songEntity =
    await (db.select(db.songTable)..where((tbl) => tbl.id.equals(songId))).getSingleOrNull();
    return songEntity;
  }

  static Future<List<SongEntity>> queryListOfSongsByArtistId(int artistId) async {
    AppDatabase db = AppDatabase();
    List<SongEntity> songEntityList =
    await (db.select(db.songTable)..where((tbl) => tbl.artistId.equals(artistId))).get();
    return songEntityList;
  }
}
