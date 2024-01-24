import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/app_database.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/song_entity.dart';

@UseRowClass(ArtistEntity)
class Artist extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  IntColumn get age => integer()();

  TextColumn get musicStyle => text()();

  // BoolColumn get isActive => boolean()(); //This field is added only for migration example

  ///Specifying which from the field above is the primary key
  @override
  Set<Column> get primaryKey => {id};
}

class ArtistEntity {
  int? id;
  String? name;
  int? age;
  String? musicStyle;
  List<SongEntity>? songEntityList;

  ArtistEntity(
      {this.id, this.name, this.age, this.musicStyle, this.songEntityList});

  ArtistEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    musicStyle = json['music_style'];
    if (json['songs'] != null) {
      songEntityList = SongEntity.fromJsonArray(json['songs']);
    }
  }

  static Future<List<ArtistEntity>> fromJsonArray(List jsonArray) async {
    return jsonArray.map((value) => ArtistEntity.fromJson(value)).toList();
  }

  ArtistCompanion toCompanion() {
    return ArtistCompanion(
        id: Value(id ?? -1),
        name: Value(name ?? ''),
        musicStyle: Value(musicStyle ?? ''),
        age: Value(age ?? 0));
  }

  static Future<void> saveSingleArtistEntity(ArtistEntity artistEntity) async {
    AppDatabase db = AppDatabase.instance();
    await db.into(db.artist).insertOnConflictUpdate(artistEntity.toCompanion());
    if (artistEntity.songEntityList != null) {
      await SongEntity.saveListOfSongsEntity(artistEntity.songEntityList ?? []);
    }
  }

  static Future<void> saveListOfArtistEntity(
      List<ArtistEntity> artistEntityList) async {
    await Future.forEach(artistEntityList, (artistEntity) async {
      await saveSingleArtistEntity(artistEntity);
    });
  }

  static Future<List<ArtistEntity>> queryAllArtists() async {
    AppDatabase db = AppDatabase.instance();
    List<ArtistEntity> artistEntityList = await db.select(db.artist).get();
    await Future.forEach(artistEntityList, (artistEntity) async {
      artistEntity.songEntityList =
          await queryListOfSongEntityByArtistId(artistEntity.id ?? -1);
    });
    return artistEntityList;
  }

  static Future<ArtistEntity?> queryArtistById(int artistId) async {
    AppDatabase db = AppDatabase.instance();
    ArtistEntity? artistEntity = await (db.select(db.artist)
          ..where((tbl) => tbl.id.equals(artistId)))
        .getSingleOrNull();
    if (artistEntity != null) {
      artistEntity.songEntityList =
          await queryListOfSongEntityByArtistId(artistEntity.id ?? -1);
    }
    return artistEntity;
  }

  static Future<List<SongEntity>> queryListOfSongEntityByArtistId(
          int artistId) async =>
      await SongEntity.queryListOfSongsByArtistId(artistId);
}
