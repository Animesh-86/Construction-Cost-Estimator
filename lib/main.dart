import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash.dart'; // << Use splash as entry

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color.fromARGB(255, 99, 43, 11),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 54, 23, 5),
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
);

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(), 
    );
  }
}
