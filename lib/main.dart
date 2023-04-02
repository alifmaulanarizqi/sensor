import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tes_synapsisid/database/db.dart';
import 'package:tes_synapsisid/moduls/login/login_page.dart';

import 'database/user/auth_provider.dart';
import 'moduls/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final prefs = await SharedPreferences.getInstance();
  final authProvider = AuthProvider(database, prefs);

  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authProvider.isLoggedIn ? HomePage() : LoginPage(authProvider: authProvider,),
    );
  }
}
