import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaraunt_app/search_page.dart';
import 'listview.dart';
import 'profile_page.dart';

String globPassword = '';
String globEmail = '';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Restaurant System',
      home: HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int currentIndex = 0;
  bool status = false;
  late LocationPermission _locationPermission;
  late Position position;
  late String placeholder;
  late String addressString;
  late Future<bool> getPosition;

  @override
  void initState() {
    super.initState();
    getPosition = getStreetAddress();
  }

  // Uses future builder so that the user's location is obtained before loading 
  // content
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getPosition,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return mainscreen();
          } else {
            return Scaffold(
                body: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
              size: 250,
              color: const Color(0xFF1A1A3F),
            )));
          }
        });
  }

  Widget mainscreen() {
    PageController pageController = PageController();

    final screens = [
      ListViewWidget(position: position, listType:1, search:""),
      SearchPage(position:position),
      ProfilePage(" ", " "),
    ];
    void onChange(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    void onNavigationTap(int index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOut
      );
    }

    return Scaffold(
      appBar: (currentIndex == 0) ? AppBar(
          title: TextField(
              controller: TextEditingController(text: addressString),
              textAlignVertical: TextAlignVertical.bottom,
              style: const TextStyle(height:0.5, fontSize: 16),
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
                  // suffixIconConstraints:
                  //     BoxConstraints(maxWidth: 90.0, maxHeight: 47.5),
                  // suffixIcon: DistanceWidget()
                  )),
          backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        ) : null,
        body: PageView(
          controller: pageController,
          children: screens,
          onPageChanged: onChange,
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedFontSize: 0.0,
          selectedFontSize: 0.0,
          currentIndex: currentIndex,
          onTap: (index) =>
              setState(() => {
                currentIndex = index,
                onNavigationTap(currentIndex)
              }),
          items: const [
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
        ));
  }

  // Checks if location service has been enabled on the user's device and requests
  // permission to use location data
  Future<Position> getLocation() async {
    status = await Geolocator.isLocationServiceEnabled();

    if (status == false) {
      await Geolocator.openLocationSettings();
      return Future.error("Location not enabled");
    }
    _locationPermission = await Geolocator.checkPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
      if (_locationPermission == LocationPermission.denied) {
        return Future.error('Location currently disabled');
      }
    }
    if (_locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location service is disabled');
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  Future<bool> getStreetAddress() async {
    position = await getLocation();
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemark[0];
    addressString = "${address.street} : ${address.locality}";
    return true;
  }
}

// class DistanceWidget extends StatefulWidget {
//   const DistanceWidget({Key? key}) : super(key: key);

//   @override
//   _DistanceWidget createState() => _DistanceWidget();
// }

// class _DistanceWidget extends State<DistanceWidget> {
//   int dropdownValue = 5;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(left: 7.5, right: 7.5),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.0),
//           border: Border.all(color: Colors.black)),
//       child: DropdownButton(
//           elevation: 0,
//           value: 5,
//           underline: Container(color: Colors.transparent),
//           onChanged: (int? newValue) {
//             dropdownValue = newValue!;
//           },
//           items: const [
//             DropdownMenuItem(child: Text('5km'), value: 5),
//             DropdownMenuItem(child: Text('10km'), value: 10),
//             DropdownMenuItem(child: Text('20km'), value: 20),
//             DropdownMenuItem(child: Text('40km'), value: 40),
//           ]),
//     );
//   }
// }
