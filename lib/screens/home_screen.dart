import 'package:billing_app/screens/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void add() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment(0, .8),
        backgroundColor: Colors.transparent,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.currency_rupee),
              label: Text('buy'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.monetization_on),
              label: Text('sell'),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: Drawer_screen(),
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.verified_outlined),
              ),
              Column(
                children: [
                  Text('Home'),
                  Text('6264972587', style: TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.support_agent_outlined),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: add,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
