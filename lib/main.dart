import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(BookReviewApp());
}

class BookReviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Review App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
