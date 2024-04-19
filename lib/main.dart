import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lunchspot_v1/pages/home_page.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox('lunchSpots');

  runApp(const LunchSpotApp());
}

class LunchSpotApp extends StatelessWidget {
  const LunchSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(59, 178, 115, 1),
          // ···
        ),
      ),
    );
  }
}
