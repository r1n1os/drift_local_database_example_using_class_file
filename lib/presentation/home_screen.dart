import 'package:drift_local_database_example_using_classes/data/local_database/entities/user_entity.dart';
import 'package:drift_local_database_example_using_classes/utils/data_source.dart';
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
    print(userEntity);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
