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

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int currentIndex = 0;
  final screens = [
    const ListViewWidget(),
    Center(child: Text('Search')),
    Center(child: Text('Profile Page')),
  ];

  final TextEditingController addressController =
      TextEditingController(text: "address placeholder");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            controller: addressController,
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
                )))),
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
