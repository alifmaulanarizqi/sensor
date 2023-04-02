import 'package:floor/floor.dart';

@entity
class CrudEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String datetime;

  CrudEntity(
    {
      this.id,
      required this.title,
      required this.datetime,
    }
  );
}