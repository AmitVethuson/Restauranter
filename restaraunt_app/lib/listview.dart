// ignore_for_file: file_names

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'restaurantpage.dart';
import 'restaurant_model.dart';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget(
      {Key? key, required this.position, required this.listType, required this.search})
      : super(key: key);
  final Position position;
  final int listType;
  final String search;
  @override
  _ListViewWidget createState() => _ListViewWidget();
}

class _ListViewWidget extends State<ListViewWidget>
    with AutomaticKeepAliveClientMixin {
  List<double> coordinates = [0.0, 0.0];
  static const apiKey = 'AIzaSyCNwihkvZR2bcVS4kcHfwC04j0cCx9-LGg';
  GooglePlace googlePlace = GooglePlace(apiKey);
  List<RestaurantModel> restaurants = [];
  List<RestaurantModel> searchedRestaurant = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      searchNear();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.listType == 1) {
      return Column(children: <Widget>[
        const Padding(padding: EdgeInsets.only(top: 10.0)),
        const Text("Near Me",
            style: TextStyle(fontSize: 30, fontFamily: 'Sora')),
        Expanded(child: restaurantlist(context, restaurants))
      ]);
    } else {
      searchPlace(widget.search);
      return Column(children: <Widget>[
        Expanded(child: restaurantlist(context, searchedRestaurant))
      ]);
    }
  }

  Widget restaurantlist(BuildContext context, List<RestaurantModel> places) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          return createRestaurantCard(index, places);
        });
  }

  Widget createRestaurantCard(int index, List<RestaurantModel> places) {
    return SizedBox(
        width: 250.0,
        child: GestureDetector(
            child: Card(
                elevation: 3.0,
                margin: const EdgeInsets.only(
                    left: 30.0, bottom: 15.0, right: 30.0),
                color: Colors.white,
                child: Row(children: <Widget>[
                  Container(
                    width: 175.0,
                    height: 175.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(places[index].name),
                          Text(places[index].rating),
                          Text(places[index].address)
                        ]),
                  ),
                  SizedBox(
                      width: 150.0,
                      height: 175.0,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.network(places[index].image,
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
                  checkFirestore(places[index].name),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantPage(
                              currentrestaurant: places[index]))),
                  print(places[index].name),
                }));
  }

  Future<void> searchNear() async {
    coordinates = [widget.position.latitude, widget.position.longitude];

    const baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String url =
        '$baseUrl?key=$apiKey&location=${coordinates[0]},${coordinates[1]}&radius=800&type=restaurant';
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> data =
        Map<String, dynamic>.from(jsonDecode(response.body));

    data["results"].forEach((item) async {
      String imageref;
      DetailsResponse? detailsRequest;
      var address;
      if (item['photos'] == null) {
        imageref = "null";
      } else {
        imageref = item['photos'][0]['photo_reference'].toString();
      }
      detailsRequest = (await googlePlace.details.get(item['place_id']));
      if (detailsRequest?.result?.formattedAddress == null) {
        address = null;
      } else {
        address = detailsRequest?.result?.formattedAddress;
      }
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

  Future<void> searchPlace(String search) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants%$search&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> data =
        Map<String, dynamic>.from(jsonDecode(response.body));

    data["results"].forEach((item) async {
      String imageref;
      DetailsResponse? detailsRequest;
      var address;
      if (item['photos'] == null) {
        imageref = "null";
      } else {
        imageref = item['photos'][0]['photo_reference'].toString();
      }

      detailsRequest = (await googlePlace.details.get(item['place_id']));
      if (detailsRequest?.result?.formattedAddress == null) {
        address = null;
      } else {
        address = detailsRequest?.result?.formattedAddress;
      }
      address = (address != null)
          ? address
          : address;
      if (address != null) {
        var image =
            'https://maps.googleapis.com/maps/api/place/photo?photoreference=$imageref&maxwidth=500&maxheight=500&key=$apiKey';
        setState(() {
          searchedRestaurant.add(RestaurantModel(
              item['name'], item['rating'].toString(), address!, image));
        });
      }
    });
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

  @override
  bool get wantKeepAlive => true;
}
