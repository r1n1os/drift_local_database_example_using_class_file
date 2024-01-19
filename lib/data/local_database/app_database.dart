import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/artist_entity.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/playlist_entity.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/playlist_with_song_entity.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/song_entity.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/user_entity.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift_dev/api/migrations.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Artist,
    Playlist,
    PlaylistWithSong,
    Song,
    User
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      ///This method is executed only the first time when database is created
      onCreate: (Migrator m) async {
        await m.createAll();
      },

      ///This method is executed every time we increase the schemaVersion number
      ///In this method is where we are handling our migration
      onUpgrade: (Migrator m, int from, int to) async {
         if (from < 2) {
          //await m.addColumn(artistTable, artistTable.dueDate);
        }
      },

      ///This method is helpful as it help us during development phase to check if we did migration correctly
      beforeOpen: (details) async {
        await validateDatabaseSchema();
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
