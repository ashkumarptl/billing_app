import 'package:billing_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData().copyWith(
        ),
        textTheme: TextTheme(
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle().copyWith(
            color: Colors.black,
                fontSize: 20,
            fontWeight: FontWeight.bold
          )
        )
      ),
      home: HomeScreen(),
    );
  }
}
