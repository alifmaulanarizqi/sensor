import 'package:shared_preferences/shared_preferences.dart';
import 'package:tes_synapsisid/database/db.dart';
import 'package:tes_synapsisid/database/user/user_entity.dart';

class AuthProvider {
  final AppDatabase database;
  final SharedPreferences prefs;

  AuthProvider(this.database, this.prefs);

  Future<String?> login(String email, String password) async {
    final user = await database.userDao.getUserByEmail(email);
    if (user != null && user.password == password) {
      await prefs.setBool('loggedIn', true);
      return null;
    }

    return "User data does not exist";
  }

  Future<String?> register(String email, String password) async {
    final user = UserEntity(
      email: email,
      password: password,
    );
    await database.userDao.insertUser(user);
    await login(email, password);
    return null;
  }

  Future<void> logout() async {
    await prefs.setBool('loggedIn', false);
  }

  bool get isLoggedIn => prefs.getBool('loggedIn') ?? false;
}