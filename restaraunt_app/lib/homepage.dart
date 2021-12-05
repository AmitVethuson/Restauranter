import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaraunt_app/search_page.dart';
import 'restaurant_list.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant System',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePageContent(),
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
                // Loading widget
                child: LoadingAnimationWidget.fourRotatingDots(
                size: 250,
                color: const Color(0xFFFF9800),
              )),
              
              backgroundColor: const Color(0xFFFFF3E0),
            );
          }
        });
  }

  // Allows for routing between the home page, search page, and page
  Widget mainscreen() {
    PageController pageController = PageController();

    // Page routes
    final screens = [
      RestaurantListWidget(position: position, listType:1, search:""),
      SearchPage(position:position),
      ProfilePage(" ", " "),
    ];
    
    void onChange(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    // When the user taps an item in the bottom navigation bar this function
    // transitions the page
    void onNavigationTap(int index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOut
      );
    }

    return Scaffold(
      // The app bar is conditional as it varies between the profile, search,
      // and home page
      appBar: (currentIndex == 0) ? AppBar(
          title: TextField(
              controller: TextEditingController(text: addressString),
              
              enabled: false,
              
              textAlignVertical: TextAlignVertical.bottom,
              
              style: const TextStyle(height:1, fontSize: 16),
              
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
                )),

          backgroundColor: const Color(0xFFFFF3E0),

          elevation: 0.0,
        
        ) : PreferredSize (
              preferredSize: const Size.fromHeight(50.0),
              child:AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0
              )),

        backgroundColor: const Color(0xFFFFF3E0),

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

          // Bottom menu bar items that route to various pages
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
  // Referenced from the geolocator plugin documentation
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

  // Location coordinates are retrieved and then converted to string format address
  Future<bool> getStreetAddress() async {
    position = await getLocation();
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemark[0];
    addressString = "${address.street}, ${address.locality}, ${address.administrativeArea}";
    return true;
  }
}
