import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/app_database.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/song_entity.dart';

@UseRowClass(ArtistEntity)
class ArtistTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get musicStyle => text()();

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

  ArtistTableCompanion toCompanion() {
    return ArtistTableCompanion(
        id: Value(id ?? -1),
        name: Value(name ?? ''),
        musicStyle: Value(musicStyle ?? ''),
        age: Value(age ?? 0));
  }

  static Future<void> saveSingleArtistEntity(ArtistEntity artistEntity) async {
    AppDatabase db = AppDatabase();
    await db.into(db.artistTable).insertOnConflictUpdate(artistEntity.toCompanion());
    if (artistEntity.songEntityList != null) {
      await SongEntity.saveListOfSongsEntity(artistEntity.songEntityList ?? []);
    }
  }

  static Future<void> saveListOfArtistEntity(
      List<ArtistEntity> artistEntityList) async {
    await Future.forEach(artistEntityList, (artistEntity) {
      saveSingleArtistEntity(artistEntity);
    });
  }

  static Future<List<ArtistEntity>> queryAllArtists() async {
    AppDatabase db = AppDatabase();
    List<ArtistEntity> artistEntityList = await db.select(db.artistTable).get();
    return artistEntityList;
  }

  static Future<ArtistEntity?> queryArtistById(int artistId) async {
    AppDatabase db = AppDatabase();
    ArtistEntity? artistEntity = await (db.select(db.artistTable)
          ..where((tbl) => tbl.id.equals(artistId)))
        .getSingleOrNull();
    return artistEntity;
  }
}
