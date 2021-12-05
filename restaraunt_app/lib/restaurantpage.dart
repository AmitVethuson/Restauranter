import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'seatingpage.dart';
import 'restaurant_model.dart';

//resturant page
class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key, required this.currentrestaurant})
      : super(key: key);

  final RestaurantModel currentrestaurant;
  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late RestaurantModel restaurant;
  @override
  Widget build(BuildContext context) {
    restaurant = widget.currentrestaurant;
    return Scaffold(
        backgroundColor: const Color(0xFFFFF3E0),

        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(widget.currentrestaurant.name,
              style: const TextStyle(color: Colors.black, fontSize: 25)),
          bottom: PreferredSize(
              child: RestaurantInfo(
                  restaurantInformation: widget.currentrestaurant),
              preferredSize: const Size.fromHeight(50.0)),
        ),
        body: SingleChildScrollView(
          child: RestarauntPageContent(
              restaurantInformation: widget.currentrestaurant),
        ));
  }

  updatePage() {
    setState(() {
      restaurant = widget.currentrestaurant;
    });
  }
}

//top bar Restaurant information
class RestaurantInfo extends StatefulWidget {
  const RestaurantInfo({Key? key, required this.restaurantInformation})
      : super(key: key);
  final RestaurantModel restaurantInformation;
  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  int waittime = 0;

  @override
  void initState() {
    super.initState();
    getQueueTime(widget.restaurantInformation.name);
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),

        //Location data
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined),
            Text(widget.restaurantInformation.address)
          ],
        ),
        const SizedBox(
          height: 10,
        ),

        //second row
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            //Rating Data display
              Row(
                children: [
                  Icon(Icons.star_border_outlined, size: iconSize),
                  Text("Rating: ${widget.restaurantInformation.rating}",
                      style: const TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
              //Hours Data Display
              Row(
                children: [
                  Icon(Icons.calendar_today, size: iconSize),
                  const Text("Hours: 11:00 AM - 7:00 PM",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
              //Queue time data display
              Row(
                children: [
                  Icon(Icons.access_time, size: iconSize),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("restaurant")
                          .where('name',
                              isEqualTo: widget.restaurantInformation.name)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Text("Queue Time:0 min");
                        }
                        final result = snapshot.data!.docs[0]["wait_time"];

                        var time = (result ~/ 60).toString() +
                            'h ' +
                            (result % 60).toString() +
                            'min ';
                        print(time);
                        return Text(time,style: TextStyle(color: Colors.black, fontSize: 13));
                      }),
                ],
              )
          ],
        ))
      ],
    );
  }

  getQueueTime(String restaurantName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("restaurant")
        .where('name', isEqualTo: restaurantName)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    setState(() {
      waittime = doc["wait_time"];
    });
  }
}

//restaraunt page  Content
class RestarauntPageContent extends StatefulWidget {
  const RestarauntPageContent({Key? key, required this.restaurantInformation})
      : super(key: key);
  final RestaurantModel restaurantInformation;

  @override
  _RestarauntPageContentState createState() => _RestarauntPageContentState();
}

class _RestarauntPageContentState extends State<RestarauntPageContent> {
  MaterialStateProperty<Color> color =
      MaterialStateProperty.all<Color>(Colors.green);
  bool isDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),

          //menu button
          Container(
            width: 350,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  //shadow
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(5, 5),
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ]),
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        print("menu");
                      },
                      child: const Text("Menu"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          primary: Colors.brown)),
                  const Icon(
                    Icons.menu_book,
                    size: 100,
                  )
                ]),
          ),

          const SizedBox(height: 20),
          //seating button
          Container(
            width: 350,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  //shadow
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(5, 5),
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ]),
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeatingPage(
                                    restaurantName:
                                        widget.restaurantInformation.name)));
                      },
                      child: const Text("Seating"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          primary: Colors.brown)),
                  const Icon(
                    Icons.chair,
                    size: 100,
                  )
                ]),
          ),

          const SizedBox(height: 10),
          
          ElevatedButton.icon(
              onPressed: (isDisabled == false)
                  ? null
                  : () {
                      updateQueue(widget.restaurantInformation.name);
                      setState(() {
                        color = MaterialStateProperty.all<Color>(Colors.red);
                        isDisabled = !isDisabled;
                      });
                      print('added');
                    },
              style: ButtonStyle(backgroundColor: color),
              icon: const Icon(Icons.person_add),
              label: const Text('Add to queue')),
          const SizedBox(height: 10),

          storeHoursWidget()
        ],
      ),
    );
  }

//description content
  Widget storeHoursWidget() {
    return Container(
        width: 350,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              //shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(5, 5),
                spreadRadius: 1,
                blurRadius: 5,
              )
            ]),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //title
            const Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Hours:",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ))),
            
            
            //hours text
            (widget.restaurantInformation.hours == null)
                ? const Text("Hours Not Available")
                : SizedBox(height: 125.0, child: ListView.builder(
                    itemCount: widget.restaurantInformation.hours!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          widget.restaurantInformation.hours![index],
                          textAlign: TextAlign.center
                        ));
                    })),
          ],
        ));
  }

  updateQueue(String restaurantName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("restaurant")
        .where('name', isEqualTo: restaurantName)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docRef = doc.reference;
    docRef.update({'wait_time': FieldValue.increment(10)});

    setState(() {});
  }
}
