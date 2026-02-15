import 'package:flutter/material.dart';

import 'pages/main_home_page.dart';
import 'pages/metronome_demo_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metronome Studio',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 146, 215, 222),
          brightness: Brightness.light,
        ),
      ),
      home: const MainHomePage(),
      routes: {'/metronome': (context) => const MetronomeDemo()},
    );
  }
}
