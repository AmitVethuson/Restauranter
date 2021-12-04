import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'notification.dart';
import 'timeformat.dart';

class SeatingPage extends StatefulWidget {
  const SeatingPage({Key? key, required this.restaurantName}) : super(key: key);
  final restaurantName;
  @override
  _SeatingPageState createState() => _SeatingPageState();
}

class _SeatingPageState extends State<SeatingPage> {
  String id = '';
  String selectedTime = "12";
  @override
  Widget build(BuildContext context) {
    // getid(widget.restaurantName);
    var temp = FirebaseFirestore.instance
        .collection("restaurant")
        .where("name", isEqualTo: widget.restaurantName!);
    return Scaffold(
      appBar: AppBar(
        title: Text("Seating"),
        actions: [
          Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(children: [
                IconButton(
                    onPressed: () {
                      timerselector(context);
                    },
                    icon: Icon(Icons.timer)),
                Text("${formatTime().timeFormat(selectedTime)}"),
              ]))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("restaurant")
              .where("name", isEqualTo: widget.restaurantName!)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text("Error: No data");
            }
            final result = snapshot.data!.docs[0];
            return SeatingPageContent(
              res: result,
              FBinstance: temp,
              time: selectedTime,
              restaurantName: widget.restaurantName,
            );
          }),
    );
  }

//format times from 24 time to 12 hour time
 

//time selector
  timerselector(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double pad = 10;
          const double fontSize = 15;
          double buttonspacer = 5;
          Color buttonColor = Colors.blue;
          return SimpleDialog(
            title: Text("Select A Time"),
            children: [
              //Time buttons
              Column(
                children: [
                  //row of times
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '12';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("12:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                      SizedBox(
                        width: buttonspacer,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '13';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("1:00 pm "),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '14';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("2:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                      SizedBox(
                        width: buttonspacer,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '15';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("3:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '16';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("4:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                      SizedBox(
                        width: buttonspacer,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '17';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("5:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '18';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("6:00 pm"),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: fontSize),
                          primary: buttonColor,
                          padding: EdgeInsets.all(pad),
                        ),
                      ),
                      SizedBox(
                        width: buttonspacer,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '19';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("7:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '20';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("8:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                      SizedBox(
                        width: buttonspacer,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '21';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("9:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '22';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("10:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                      SizedBox(
                        width: buttonspacer,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTime = '23';
                          });
                          return Navigator.pop(context);
                        },
                        child: Text("11:00 pm"),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: fontSize),
                            primary: buttonColor,
                            padding: EdgeInsets.all(pad)),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }
}

class SeatingPageContent extends StatefulWidget {
  SeatingPageContent(
      {Key? key,
      required this.res,
      required this.FBinstance,
      required this.time,
      required this.restaurantName})
      : super(key: key);
  final res;
  var FBinstance;
  String time;
  String restaurantName;
  @override
  _SeatingPageContentState createState() => _SeatingPageContentState();
}

class _SeatingPageContentState extends State<SeatingPageContent> {
  @override
  Widget build(BuildContext context) {
   
    Color iconColor = Colors.blue;

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(50),
      children: [
        //table 1 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table1")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async{
                      String tabletime = "table1.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus() == false) {
                        addReservation(widget.restaurantName, widget.time, "1",tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table1")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 1")
          ],
        )),
        //table 2 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table2")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async{
                      String tabletime = "table2.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus()  == false) {
                        addReservation(widget.restaurantName, widget.time, "2",tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table2")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 2")
          ],
        )),
        //table 3 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table3")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async {
                      String tabletime = "table3.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus()  == false) {
                        addReservation(widget.restaurantName, widget.time, "3", tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table3")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 3")
          ],
        )),
        //table 4 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table4")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async{
                      String tabletime = "table4.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus()  == false) {
                        addReservation(widget.restaurantName, widget.time, "4", tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table4")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 4")
          ],
        )),
        //table 5 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table5")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async{
                      String tabletime = "table5.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus()  == false) {
                        addReservation(widget.restaurantName, widget.time, "5", tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table5")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 5")
          ],
        )),
        //table 6 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table6")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async {
                      String tabletime = "table6.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus() == false) {
                        addReservation(widget.restaurantName, widget.time, "6", tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table6")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 6")
          ],
        )),
        //table 7 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table7")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async{
                      String tabletime = "table7.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus()== false) {
                        addReservation(widget.restaurantName, widget.time, "7", tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table7")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 7")
          ],
        )),
        //table 8 button
        Center(
            child: Column(
          children: [
            IconButton(
              onPressed: (widget.res.get("table8")[widget.time]
                          ["isAvailable"] ==
                      false)
                  ? null
                  : () async{
                      String tabletime = "table8.${widget.time}.isAvailable";
                      //check if reservations were already made
                      if (await checkReservationStatus()  == false) {
                        addReservation(widget.restaurantName, widget.time, "8", tabletime);
                      } else {
                        _errorReservationPrompt(context);
                      }
                    },
              icon: Icon(Icons.food_bank_outlined,
                  color: (widget.res.get("table8")[widget.time]
                              ["isAvailable"] ==
                          true)
                      ? Colors.blue
                      : Colors.red),
              iconSize: 100,
            ),
            Text("Table 8")
          ],
        )),
      ],
    );
  }

//change availability of table to false (aka taken)
  updateTablesAvailability(String tableTime) async {
    print("---------------");
    await widget.FBinstance.get().then((value) {
      var selectedId = value.docs[0].id;
      FirebaseFirestore.instance
          .collection("restaurant")
          .doc(selectedId)
          .update({tableTime: false}).then(
              (value) => print('Table availablility updated'));
    });
  }

  //shows error dialog when user tries to book a second reservation
  _errorReservationPrompt(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Reservation Error"),
            content: Text("You already have a reservation"),
            actions: [
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

//check if user reservation status
  checkReservationStatus() async {
    bool reservationStatus = true;
    List<Map<String, dynamic>> record = await DBHelper.dbHelper.getAllInfo();
    String email = record[0]["email"];

    QuerySnapshot a = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    QueryDocumentSnapshot doc = a.docs[0];
    reservationStatus = doc["isReserved"];
    return reservationStatus;
  }

  //add reservation details to user account, and calls updateTablesAvailability
  addReservation(String RestaurantName, String time, String tableNumber, String tabletime) async {
    List<Map<String, dynamic>> record = await DBHelper.dbHelper.getAllInfo();
    String email = record[0]["email"];
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are yousure you want to book Table${tableNumber} at ${int.parse(time) - 12}pm?"),
          actions: [
            TextButton(
              onPressed: (){
                return Navigator.pop(context);
              },
              child: Text("Cancel")
            ),
            TextButton(
              onPressed: () async{
                MyNotification(context).showNotification(int.parse(widget.time),RestaurantName,time);
                await FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: email)
                  .get()
                  .then((value) {
                    var userId = value.docs[0].id;
                    FirebaseFirestore.instance.collection('users').doc(userId).update({
                      'isReserved': true,
                      'reservation': {
                        'restarauntName': '$RestaurantName',
                        'tableNumber': '$tableNumber',
                        'reservationTime': '$time'
                      }
                }).then((value) => print("Table reserved"));
                });
                updateTablesAvailability(tabletime);
                return Navigator.pop(context);
              }, 
              child: Text("Confirm")
            ),
          ],
        );
      }
    );
  }

}
