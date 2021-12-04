import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text("${widget.currentrestaurant.name}",
              style: TextStyle(color: Colors.black, fontSize: 25)),
          bottom: PreferredSize(
              child: RestaurantInfo(
                  restaurantInformation: widget.currentrestaurant),
              preferredSize: Size.fromHeight(50)),
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
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("restaurant");
    double iconSize = 22;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 5,
        ),

        //Location Display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined),
            Text("${widget.restaurantInformation.address}")
          ],
        ),
        SizedBox(
          height: 10,
        ),

        //second row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Rating Data display
            Container(
              child: Row(
                children: [
                  Icon(Icons.star_border_outlined, size: iconSize),
                  Text("Rating: ${widget.restaurantInformation.rating}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
            ),
            //Hours Data Display
            Container(
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: iconSize),
                  Text("Hours: 12:00 PM - 11:00 PM",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
            ),
            //Queue time data display
            Container(
                child: Row(
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
                        return Text("Queue Time:0 min");
                      }
                      final result = snapshot.data!.docs[0]["wait_time"];

                      var time = (result ~/ 60).toString() +
                          'h ' +
                          (result % 60).toString() +
                          'min ';
                      print(time);
                      return Text('${time}');
                    }),
              ],
            ))
          ],
        )
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
  MaterialStateProperty<Color> color =
      MaterialStateProperty.all<Color>(Colors.green);
  bool isDisabled = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),

          //restaurant description
          description(),
          SizedBox(height: 10),
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
              icon: Icon(Icons.person_add),
              label: Text('Add to queue')),
          //menu button
          Container(
            width: 350,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //Navigator.push(
                        //context, MaterialPageRoute(builder: (context) => MenuPage(restaurantName: widget.restaurantInformation.name,currentTime: "${now+1}",)));
                      },
                      child: Text("Menu"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50), primary: Colors.brown)),
                  Icon(
                    Icons.menu_book,
                    size: 100,
                  )
                ]),
          ),

          SizedBox(height: 30),
          //seating button
          Container(
            width: 350,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //get current hour
                        int now = DateTime.now().hour;

                        //allow the ability to book restaurant prior to open time
                        if (now < 12) {
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
                      child: Text("Seating"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50), primary: Colors.brown)),
                  Icon(
                    Icons.chair,
                    size: 100,
                  )
                ]),
          ),
        ],
      ),
    );
  }

//description content
  Widget description() {
    //temp value ----remove after implementing api value
    String descriptionText =
        " There was a time when he would have embraced the change that was coming. In his youth, he sought adventure and the unknown, but that had been years ago. He wished he could go back and learn to find the excitement that came with change but it was useless. ";
    return Container(
        width: 350,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              //shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(5, 10),
                spreadRadius: 1,
                blurRadius: 5,
              )
            ]),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //title
            Text("Description:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            //description text
            Text(descriptionText),
          ],
        ));
  }

//update queue value in db
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
