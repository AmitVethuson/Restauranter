import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeatingPage extends StatefulWidget {
  const SeatingPage({Key? key, required this.restaurantName}) : super(key: key);
  final restaurantName;
  @override
  _SeatingPageState createState() => _SeatingPageState();
}

class _SeatingPageState extends State<SeatingPage> {
  String id = '';
  @override
  Widget build(BuildContext context) {
    // getid(widget.restaurantName);

    return Scaffold(
        appBar: AppBar(
          title: Text("Seating"),
        ),
        body:
        StreamBuilder(
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
              
            
            //this is temp items for getting data------------------
              // var t = result.get("table5");
              // print(t["14"]["isAvailable"]);
            //----------------------------------
              return SeatingPageContent();
            })
            );
  }


}

class SeatingPageContent extends StatefulWidget {
  const SeatingPageContent({Key? key}) : super(key: key);
  
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
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.food_bank_outlined, color: iconColor),
          iconSize: 100,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.food_bank_outlined, color: iconColor),
          iconSize: 100,
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.food_bank_outlined, color: iconColor),
            iconSize: 100),
      ],
    );
  }
}
