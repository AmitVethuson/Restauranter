import 'package:flutter/material.dart';

import 'listview.dart';
import 'profile_page.dart';
// import 'listview.dart';
String globPassword = '';
String globEmail = '';

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
    ProfilePage(" "," "),

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
            style: const TextStyle(height: 0.1, fontSize: 16),
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.location_pin,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black,
                width: 1.0,
              )),
              suffixIconConstraints: BoxConstraints(
                maxWidth: 90.0,
                maxHeight: 50.0
              ),
              suffixIcon: DistanceWidget()
            )),
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

class DistanceWidget extends StatefulWidget {
  const DistanceWidget({Key? key}) : super(key: key);

  @override
  _DistanceWidget createState() => _DistanceWidget();
}

class _DistanceWidget extends State<DistanceWidget> {
  int dropdownValue = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:7.5, right:7.5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),border:Border.all(color: Colors.black)),
        child: DropdownButton(
          elevation: 0,
        value: 5,
        underline: Container(color:Colors.transparent),
        onChanged: (int? newValue) {
          dropdownValue = newValue!;
        },
        items: const [
          DropdownMenuItem(child: Text('5km'), value: 5),
          DropdownMenuItem(child: Text('10km'), value: 10),
          DropdownMenuItem(child: Text('20km'), value: 20),
          DropdownMenuItem(child: Text('40km'), value: 40),
      ]),
      );
  }
}
