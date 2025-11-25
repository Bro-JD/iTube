
import 'package:flutter/material.dart';
import 'youtube_player_screen.dart'; // Make sure this path matches your file location

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iTube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      home: const YouTubePlayerScreen(),
    );
  }
}
