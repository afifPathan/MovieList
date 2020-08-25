import 'package:flutter/material.dart';
import 'package:webclues_practical/ui/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
