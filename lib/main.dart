import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/db.dart';
import './screens/home.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value:DbProvider(),
          child: MaterialApp(
        title: 'Exchange Rates',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}


