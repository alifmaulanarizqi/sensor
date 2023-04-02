import 'package:floor/floor.dart';
import 'package:tes_synapsisid/database/user/user_entity.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM UserEntity WHERE email = :email')
  Future<UserEntity?> getUserByEmail(String email);

  @insert
  Future<void> insertUser(UserEntity user);
}