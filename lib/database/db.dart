import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:tes_synapsisid/database/crud/crud_entity.dart';

import 'crud/crud_dao.dart';
import 'user/user_dao.dart';
import 'user/user_entity.dart';

part 'db.g.dart'; // the generated code will be there

@Database(version: 1, entities: [UserEntity, CrudEntity])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  CrudDao get crudDao;
}