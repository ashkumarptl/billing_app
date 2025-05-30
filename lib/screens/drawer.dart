import 'package:flutter/material.dart';

class Drawer_screen extends StatelessWidget {
  const Drawer_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
          ),
          Text('Ash', style: TextStyle(fontSize: 20),),
          Text('email@email.com'),
          Divider(),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
              ListTile(
                leading: Icon(Icons.note),
                title: Text('Sell list'),
              ),
              ListTile(
                leading: Icon(Icons.note),
                title: Text('Purchase list'),
              ),
              ListTile(
                leading: Icon(Icons.summarize),
                title: Text('Report'),
              ),
              ListTile(
                leading: Icon(Icons.inventory),
                title: Text('Inventory')
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ],
          )
          ]
      ),
    );
  }
}
