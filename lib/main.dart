import 'package:billing_app/screens/home_screen.dart';
import 'package:billing_app/screens/select_item.dart';
import 'package:billing_app/screens/sell_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:hive/hive.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

 // final appDocumentDir = await getApplicationDocumentsDirectory();
  //Hive.init(appDocumentDir.path);

  // Register your Hive adapters here
  // Hive.registerAdapter(ItemModelAdapter());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle().copyWith(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/home': (_) => HomeScreen(),
        '/select_item': (_) => SelectItem(),
        '/inventory':(_)=>SelectItem(),
        '/sellReport':(_)=>SellReports(),
      },
      home: HomeScreen(),
    );
  }
}
