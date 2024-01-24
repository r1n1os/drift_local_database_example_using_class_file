import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/app_database.dart';

@UseRowClass(SongEntity)
class Song extends Table {
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

  SongEntity({this.id, this.name, this.duration, this.artistId, /*this.artistEntity*/});

  SongEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    if(json['artist'] != null){
      artistId = json['artist']['id'];
    }
  }

  static List<SongEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((value) => SongEntity.fromJson(value)).toList();
  }

  SongCompanion toCompanion() {
    return SongCompanion(
        id: Value(id ?? -1),
        name: Value(name ?? ''),
        duration: Value(duration ?? 0),
        artistId: Value(artistId ?? 0));
  }

  static Future<void> saveSingleSongEntity(SongEntity songEntity) async {
    AppDatabase db = AppDatabase.instance();
    await db
        .into(db.song)
        .insertOnConflictUpdate(songEntity.toCompanion());
  }

  static Future<void> saveListOfSongsEntity(
      List<SongEntity> songEntityList) async {
    await Future.forEach(songEntityList, (songEntity) async {
      await saveSingleSongEntity(songEntity);
    });
  }

  static Future<List<SongEntity>> queryAllSongs() async {
    AppDatabase db = AppDatabase.instance();
    List<SongEntity> songEntityList = await db.select(db.song).get();
    return songEntityList;
  }

  static Future<SongEntity?> querySongById(int songId) async {
    AppDatabase db = AppDatabase.instance();
    SongEntity? songEntity = await (db.select(db.song)
          ..where((tbl) => tbl.id.equals(songId)))
        .getSingleOrNull();
    return songEntity;
  }

  static Future<List<SongEntity>> queryListOfSongsByArtistId(
      int artistId) async {
    AppDatabase db = AppDatabase.instance();
    List<SongEntity> songEntityList = await (db.select(db.song)
          ..where((tbl) => tbl.artistId.equals(artistId)))
        .get();
    return songEntityList;
  }
}
