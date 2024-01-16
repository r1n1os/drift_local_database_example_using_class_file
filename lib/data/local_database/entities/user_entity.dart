import 'package:drift/drift.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/app_database.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/playlist_entity.dart';

@UseRowClass(UserEntity)
class UserTable extends Table {
  IntColumn get id => integer()();
  TextColumn get username => text()();
  TextColumn get musicStyle => text()();
  TextColumn get favoriteSongName => text()();

  ///Specifying which from the field above is the primary key
  @override
  Set<Column> get primaryKey => {id};
}

class UserEntity {
  int? id;
  String? username;
  String? musicStyle;
  String? favoriteSongName;
  PlaylistEntity? playlistEntity;

  UserEntity(
      {this.id,
      this.username,
      this.musicStyle,
      this.favoriteSongName,
      this.playlistEntity});

  UserTableCompanion toCompanion() {
    return UserTableCompanion(
      id: Value(id ?? -1),
      username: Value(username ?? ''),
      musicStyle: Value(musicStyle ?? ''),
      favoriteSongName: Value(favoriteSongName ?? ''),
    );
  }

  static Future<void> saveSingleUserEntity(UserEntity userEntity) async {
    AppDatabase db = AppDatabase();
    await db.into(db.userTable).insertOnConflictUpdate(userEntity.toCompanion());
    if (userEntity.playlistEntity != null) {
      await PlaylistEntity.saveSinglePlaylistEntity(userEntity.playlistEntity!);
    }
  }

  static Future<void> saveListOfUserEntity(
      List<UserEntity> userEntityList) async {
    await Future.forEach(userEntityList, (userEntity) {
      saveSingleUserEntity(userEntity);
    });
  }

 static Future<List<UserEntity>> queryAllUsers() async {
    AppDatabase db = AppDatabase();
    List<UserEntity> userEntityList = await db.select(db.userTable).get();
    return userEntityList;
  }

  static Future<UserEntity?> queryUserById(int userId) async {
    AppDatabase db = AppDatabase();
    UserEntity? userEntity =
        await (db.select(db.userTable)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    return userEntity;
  }
}
