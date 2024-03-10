import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_galaxy_demo_app/app/home_page.dart';
import 'package:liquid_galaxy_demo_app/app/settings.dart';
import 'package:liquid_galaxy_demo_app/app/ssh.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    final ssh = SSH(); 
    ssh.connectToLG(); 
    final String imageUrl = 'https://i.imgur.com/0rCWmFO.png'; 
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(ssh: ssh,), 
        '/settings': (context) => const SettingsPage(), 
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEEEEE),
        appBarTheme: AppBarTheme(
          color: Color(0xFF111111),
        ),
      ),
    );
  }
}


