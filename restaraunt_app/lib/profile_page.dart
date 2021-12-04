import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'db_helper.dart';
import 'main.dart';
import 'timeformat.dart';
import 'notification.dart';
void main() async {
  print("test");
}

class ProfilePage extends StatefulWidget {
  String email = '';
  String password = '';
  ProfilePage(this.email, this.password);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  List<String> info = [" ", " ", " ", " ", " ", " "];

  @override
  void initState() {
    // TODO: implement initState
    getAllData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Column(
        children: <Widget>[
          Container(
            height: 250,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: Row(
                      //the is a temp comment out
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Center(
                              child: Text('Profile Page',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    _DisplayReservations(context, info[3]);
                                    // print(info[3]);
                                  },
                                  child: Icon(Icons.restaurant))),
                        )
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Stack(fit: StackFit.loose, children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/images/default_prof.png',
                                      scale: 1.0),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ],
                      ),
                    ])),
              ],
            ),
          ),
          Container(
              color: Color(0xffFFFFFF),
              child: ElevatedButton(
                  onPressed: () async {
                    int re = await DBHelper.dbHelper.delete(info[4]);

                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: Text("Logout"))),
          Container(
              color: Color(0xffFFFFFF),
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Account Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: info[1] + " " + info[2],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email Adress',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  decoration:
                                      InputDecoration(hintText: info[3]),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Phone Number',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  decoration:
                                      InputDecoration(hintText: info[4]),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Country',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                  'Province',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: TextField(
                                    readOnly: true,
                                    decoration:
                                        InputDecoration(hintText: info[0]),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  decoration:
                                      InputDecoration(hintText: "Ontario"),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                    ]),
              ))
        ],
      ),
    ]));
  }

  getAllData() async {
    List<Map<String, dynamic>> record = await DBHelper.dbHelper.getAllInfo();
    // int re = await DBHelper.dbHelper.delete("6471231234");
    // int de = await DBHelper.dbHelper.delete("123-456-7890");

    info.clear();
    setState(() {
      record.forEach((element) {
        print(element);
        info.add(element["country"]);
        info.add(element["firstName"]);
        info.add(element["lastName"]);
        info.add(element["email"]);
        info.add(element["password"]);
        info.add(element["province"]);
        info.add(element["province"]);
      });
    });

    // setState(() {
    //   record.forEach((element) {
    //     info1.add(element.toString());
    //     info = info1;
    //   });
    // });
  }

//reservation display
  _DisplayReservations(BuildContext context, String email) async {
    QuerySnapshot User = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    QueryDocumentSnapshot doc = User.docs[0];
    Map<String, dynamic> reservationINFO = doc["reservation"];
    String restarauntName = reservationINFO["restarauntName"];
    String reservationTime = reservationINFO["reservationTime"];
    String tableNumber = reservationINFO["tableNumber"];

    //check if reservation is placed
    if (restarauntName == "empty") {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Current Reservations"),
              content: Text("No reservations are placed"),
              actions: [
                TextButton(
                    onPressed: () {
                      return Navigator.pop(context);
                    },
                    child: Text("OK")),
              ],
            );
          });
    } else {
      //display reservation time
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Current Reservations"),
              content: Text(
                  "Your Current Reservation is $restarauntName at ${formatTime().timeFormat(reservationTime)} at Table $tableNumber"),
              actions: [
                TextButton(
                    onPressed: () {
                      return Navigator.pop(context);
                    },
                    child: Text("OK")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      return _cancelReservation(context, email,restarauntName,reservationTime,tableNumber);
                    },
                    child: Text("Cancel Reservation")),
              ],
            );
          });
    }
  }

//cancel reservation prompt
  _cancelReservation(BuildContext context, String email, String restaruantName, String ReservationTime, String tablenumber) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          //get table time
          String tabletime = "table$tablenumber.$ReservationTime.isAvailable";
          return AlertDialog(
            title: Text("Cancel Reservations"),
            content: Text("Are you sure you want to cancel reservation"),
            actions: [
              TextButton(
                  onPressed: () async {

                    //change user reservation
                    await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get()
                      .then((value) {
                      var userId = value.docs[0].id;
                      FirebaseFirestore.instance.collection('users').doc(userId)
                        .update({
                        'isReserved': false,
                        'reservation': {
                          'restarauntName': 'empty',
                          'tableNumber': 'empty',
                          'reservationTime': 'empty'
                        }
                      }).then((value) =>
                              print("Reservation has been Cancelled"));
                    });

                    //update restaurant information
                    await FirebaseFirestore.instance.collection("restaurant").where("name", isEqualTo: restaruantName).get()
                    .then((value) {
                      var userId = value.docs[0].id;
                      FirebaseFirestore.instance.collection('restaurant').doc(userId).update({tabletime: true})
                      .then((value) =>
                              print("Reservation has been Cancelled"));
                    });
                    return Navigator.pop(context);
                  },
                  child: Text("Yes, Cancel Reservation")),
                  
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: Text("No, Do not cancel Reservation")),
            ],
          );
        });
  }

//time formater
  
}
