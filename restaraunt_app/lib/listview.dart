// ignore_for_file: file_names

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'restaurantpage.dart';
import 'restaurant_model.dart';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({Key? key}) : super(key: key);
  @override
  _ListViewWidget createState() => _ListViewWidget();
}

class _ListViewWidget extends State<ListViewWidget> {
  List<double> coordinates = [0.0, 0.0];
  late Position position;
  static const apiKey = 'AIzaSyCNwihkvZR2bcVS4kcHfwC04j0cCx9-LGg';
  bool status = false;
  late LocationPermission _locationPermission;
  GooglePlace googlePlace = GooglePlace(apiKey);
  List<RestaurantModel> restaurants = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      searchNear("pizza");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(padding: EdgeInsets.only(top: 10.0)),
      Text(
        "Near Me",
        style: TextStyle(fontSize: 30, fontFamily: 'Sora'),
      ),
      Expanded(child: restaurantlist(context))
    ]);
  }

  Widget restaurantlist(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: restaurants.length,
        itemBuilder: (BuildContext context, int index) {
          return createRestaurantCard(index);
        });
  }

  Widget createRestaurantCard(int index) {
    return SizedBox(
        width: 250.0,
        child: GestureDetector(
            child: Card(
                elevation: 3.0,
                margin: EdgeInsets.only(left: 30.0, bottom: 15.0, right: 30.0),
                color: Colors.white,
                child: Row(children: <Widget>[
                  Container(
                    width: 175.0,
                    height: 175.0,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(restaurants[index].name),
                          Text(restaurants[index].rating),
                          Text(restaurants[index].address)
                        ]),
                  ),
                  Container(
                      width: 150.0,
                      height: 175.0,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.network(restaurants[index].image,
                                width: 125.0, height: 125.0, fit: BoxFit.cover,
                                errorBuilder: ((BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/images/logo.png',
                                width: 125.0,
                                height: 125.0,
                              );
                            })),
                          ])),
                ])),
            onTap: () async => {
                  checkFirestore(restaurants[index].name),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantPage(
                              currentrestaurant: restaurants[index]))),
                  print(restaurants[index].name),
                }));
  }

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

  Future<void> searchNear(String keyword) async {
    Position position = await getLocation();
    coordinates = [position.latitude, position.longitude];
    getStreetAddress(position);

    const baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String url =
        '$baseUrl?key=$apiKey&location=${coordinates[0]},${coordinates[1]}&radius=800&type=restaurant';
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> data =
        Map<String, dynamic>.from(jsonDecode(response.body));

    data["results"].forEach((item) async {
      String imageref;
      if (item['photos'] == null) {
        imageref = "null";
      } else {
        imageref = item['photos'][0]['photo_reference'].toString();
      }
      var detailsRequest =
          await this.googlePlace.details.get(item['place_id'].toString());
      var address = detailsRequest!.result!.formattedAddress;
      address = (address != null)
          ? address.substring(0, address.indexOf(','))
          : address;
      if (address != null) {
        var image =
            'https://maps.googleapis.com/maps/api/place/photo?photoreference=$imageref&maxwidth=500&maxheight=500&key=$apiKey';
        setState(() {
          restaurants.add(RestaurantModel(
              item['name'], item['rating'].toString(), address!, image));
        });
      }
    });
  }

  Future<void> getStreetAddress(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemark[0];
    print("${address.street} : ${address.locality}");
  }

  checkFirestore(String name) async {
    await FirebaseFirestore.instance
        .collection("restaurant")
        .where('name', isEqualTo: name)
        .get()
        .then((value) => {
              if (value.size == 0)
                FirebaseFirestore.instance.collection("restaurant").add({
                  'name': name,
                  'wait_time': 0,
                  'table1': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                  'table2': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                  'table3': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                  'table4': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                  'table5': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                  'table6': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                  'table7': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                  'table8': {
                    '12': {'time': 12, 'isAvailable': true},
                    '13': {'time': 13, 'isAvailable': true},
                    '14': {'time': 14, 'isAvailable': true},
                    '15': {'time': 15, 'isAvailable': true},
                    '16': {'time': 16, 'isAvailable': true},
                    '17': {'time': 17, 'isAvailable': true},
                    '18': {'time': 18, 'isAvailable': true},
                    '19': {'time': 19, 'isAvailable': true},
                    '20': {'time': 20, 'isAvailable': true},
                    '21': {'time': 21, 'isAvailable': true},
                    '22': {'time': 22, 'isAvailable': true},
                    '23': {'time': 23, 'isAvailable': true}

                  },
                })
            });
  }
}
