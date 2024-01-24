import 'package:drift_local_database_example_using_classes/data/local_database/entities/artist_entity.dart';
import 'package:drift_local_database_example_using_classes/data/local_database/entities/user_entity.dart';
import 'package:drift_local_database_example_using_classes/utils/data_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    _parseData();
    super.initState();
  }

  void _parseData() async {
    List<UserEntity> userEntity = await UserEntity.fromJsonArray(DataSource.dataSource['Users']);
    _saveDataIntoLocalDatabase(userEntity);
    _retrieveDataFromLocalDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void _saveDataIntoLocalDatabase(List<UserEntity> userEntity) async {
    await UserEntity.saveListOfUserEntity(userEntity);

  }

  void _retrieveDataFromLocalDatabase() async {
    List<UserEntity> userEntityList =  await UserEntity.queryAllUsers();
    List<ArtistEntity> artistEntityList = await ArtistEntity.queryAllArtists();
    if (kDebugMode) {
      print("Queried users: $userEntityList");
      print("Queried artist: $artistEntityList");
    }
  }
}
