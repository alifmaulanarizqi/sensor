import 'package:floor/floor.dart';
import 'crud_entity.dart';

@dao
abstract class CrudDao {
  @Query('SELECT * FROM CrudEntity')
  Future<List<CrudEntity>?> getAllData();

  @insert
  Future<void> insertUser(CrudEntity crud);
}