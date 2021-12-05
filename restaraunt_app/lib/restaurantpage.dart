import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaraunt_app/db_helper.dart';
import 'seatingpage.dart';
import 'restaurant_model.dart';
import 'menu_page.dart';

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
    //get current restaurant information
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

//update page
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
  //current Restaurant information
  final RestaurantModel restaurantInformation;
  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  int waittime = 0;

//get queue time when initiated
  @override
  void initState() {
    super.initState();
    getQueueTime(widget.restaurantInformation.name);
  }

  @override
  Widget build(BuildContext context) {
    //get restaurant collection
    double iconSize = 22;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),

        //Location Display
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
          children: [
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
                const Text("Open Now",
                    style: TextStyle(color: Colors.black, fontSize: 12)),
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
                      return Text(time,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13));
                    }),
              ],
            )
          ],
        ))
      ],
    );
  }

  //get waittime from restaurant in db
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
  MaterialStateProperty<Color> enabledColor =
      MaterialStateProperty.all<Color>(Colors.red);
  bool isDisabled = false;

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MenuPage()));
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
                        //get current hour
                        int now = DateTime.now().hour;

                        //allow the ability to book restaurant prior to open time
                        if (now < 12 || now ==23) {
                          now = 11;
                        }
                        //display seating page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeatingPage(
                                      restaurantName:
                                          widget.restaurantInformation.name,
                                      currentTime: "${now + 1}",
                                    )));
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
          addToQueueWidget(),
          const SizedBox(height: 10),

          storeHoursWidget()
        ],
      ),
    );
  }

  //Widget for the restaurant hours
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
                child: Text("Hours:",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20))),

            //hours text
            (widget.restaurantInformation.hours == null)
                ? const Text("Hours Not Available")
                : SizedBox(
                    height: 125.0,
                    child: ListView.builder(
                        itemCount: widget.restaurantInformation.hours!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                  widget.restaurantInformation.hours![index],
                                  textAlign: TextAlign.center));
                        })),
          ],
        ));
  }

  // Add and Remove to/from queue button widget
  Widget addToQueueWidget() {
    return FutureBuilder<bool>(
        future: checkQueueStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 5.0)),
                  ElevatedButton.icon(
                      onPressed: (isDisabled == true)
                          ? null
                          : () async {
                              if (await checkQueueStatus() == false) {
                                updateQueue(widget.restaurantInformation.name);
                                updateQueueStatus(true);
                                checkQueueStatus();
                              }
                            },
                      style: ButtonStyle(backgroundColor: enabledColor),
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add to Queue')),
                  ElevatedButton.icon(
                      onPressed: (isDisabled == false)
                          ? null
                          : () async {
                              if (await checkQueueStatus() == true) {
                                updateQueueStatus(false);
                                checkQueueStatus();
                              }
                            },
                      style: ButtonStyle(backgroundColor: enabledColor),
                      icon: const Icon(Icons.person_remove),
                      label: const Text('Remove from Queue')),
                  const Padding(padding: EdgeInsets.only(right: 5.0)),
                ]);
          } else {
            return const Text("");
          }
        });
  }

//update queue value in firestore
  updateQueue(String restaurantName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("restaurant")
        .where('name', isEqualTo: restaurantName)
        .get();

    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docRef = doc.reference;
    docRef.update({'wait_time': FieldValue.increment(10)});
  }

  // Removes the person from the queue time
  removeFromQueue(String restaurantName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("restaurant")
        .where('name', isEqualTo: restaurantName)
        .get();

    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docRef = doc.reference;
    docRef.update({'wait_time': FieldValue.increment(-10)});
  }

  // Checks if the user is already in queue
  Future<bool> checkQueueStatus() async {
    bool reservationStatus = true;
    List<Map<String, dynamic>> record = await DBHelper.dbHelper.getAllInfo();
    String email = record[0]["email"];

    QuerySnapshot a = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    QueryDocumentSnapshot doc = a.docs[0];
    reservationStatus = doc["isInQueue"];
    setState(() {
      isDisabled = reservationStatus;
    });
    return reservationStatus;
  }

  // Updates the user queue status so that they are not able to enter another
  // queue until they leave the current queue
  updateQueueStatus(bool status) async {
    List<Map<String, dynamic>> record = await DBHelper.dbHelper.getAllInfo();
    String email = record[0]["email"];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get();

    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    DocumentReference docRef = doc.reference;
    docRef.update({'isInQueue': status});
    if (status == true) {
      docRef.update({'inQueueRestaurant': widget.restaurantInformation.name});
    } else {
      removeFromQueue(doc['inQueueRestaurant']);
    }
  }
}
