import 'package:flutter/material.dart';
import 'package:myapp/Pages/EmojiEdit.dart';
import 'package:myapp/Services/EmojiChangeNotifier.dart';
import 'package:provider/provider.dart';
import 'Pages/HomeScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmojiChangeNotifier>(
      create: (context) => EmojiChangeNotifier(),
      child: MaterialApp(
        routes: {
          '/': (context) => const HomeScreen(),
          '/EmojiEdit': (context) => const EmojiEdit(),
        },
      ),
    );
  }
}
