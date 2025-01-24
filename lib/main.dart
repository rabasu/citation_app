import 'package:flutter/material.dart';
import 'package:citation_app/screens/list_screen.dart';
void main() {
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita Search',  // titleを追加
      theme: ThemeData( // themeを追加
        primarySwatch: Colors.green,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF55C500),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
      ),
      home: const ListScreen(), // ListScreenを設定
    );
  }
}