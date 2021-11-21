
import 'package:flutter/material.dart';

import 'listview.dart';
// import 'listview.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant System',
      home: HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          textAlignVertical: TextAlignVertical.bottom,
          style: TextStyle(height: 0.1, fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.location_pin,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.0,
              ))
            ) 
        ),
        backgroundColor: const Color.fromRGBO(242,242,242,1),),
      body: const ListViewWidget(),
    );
  }
}