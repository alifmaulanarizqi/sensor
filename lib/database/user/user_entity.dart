import 'package:floor/floor.dart';

@entity
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String email;
  final String password;

  UserEntity(
    {
      this.id,
      required this.email,
      required this.password,
    }
  );
}