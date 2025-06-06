import 'package:billing_app/provider/item_provider.dart';
import 'package:billing_app/screens/home_screen.dart';
import 'package:billing_app/screens/select_item.dart';
import 'package:billing_app/screens/sell_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:billing_app/model/item_model.dart';
import 'package:billing_app/model/record_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ItemsAdapter());
  Hive.registerAdapter(BillAdapter());

  final itemsBox = await Hive.openBox<Items>('itemsBox');
  final billsBox = await Hive.openBox<Bill>('billsBox');

  runApp(
    ProviderScope(
      overrides: [
        itemsBoxProvider.overrideWithValue(itemsBox),
        billsBoxProvider.overrideWithValue(billsBox),
      ],
      child: const MyApp(),
    ),
  );
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
