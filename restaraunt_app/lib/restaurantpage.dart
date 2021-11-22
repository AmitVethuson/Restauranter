import 'package:flutter/material.dart';
import 'restaurant_model.dart';

//resturant page
class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key,required this.currentrestaurant}) : super(key: key);
  final RestaurantModel currentrestaurant;
  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text("${widget.currentrestaurant.name}",
              style: TextStyle(color: Colors.black, fontSize: 25)),
          bottom: PreferredSize(
              child: RestaurantInfo(restaurantInformation:widget.currentrestaurant), preferredSize: Size.fromHeight(50)),
        ),
        body: SingleChildScrollView(
          child: RestarauntPageContent(),
        ));
  }
}

//top bar Restaurant information
class RestaurantInfo extends StatefulWidget {
  const RestaurantInfo({Key? key,required this.restaurantInformation}) : super(key: key);
  final RestaurantModel restaurantInformation;
  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  @override
  Widget build(BuildContext context) {
    double iconSize = 22;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 5,
        ),

        //Location data
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.location_on_outlined), Text("${widget.restaurantInformation.address}")],
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
                  Icon(Icons.star_border_outlined,size: iconSize),
                  Text("Rating: ${widget.restaurantInformation.rating}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
            ),
            //Hours Data Display
            Container(
              child: Row(
                children: [
                  Icon(Icons.calendar_today,size: iconSize),
                  Text("Hours: 11:00 AM - 7:00 PM",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
            ),
            //Queue time data display
            Container(
                child: Row(
              children: [
                Icon(Icons.access_time,size: iconSize),
                Text("Queue Time: 20 min",
                    style: TextStyle(color: Colors.black, fontSize: 12))
              ],
            ))
          ],
        )
      ],
    );
  }
}



//restaraunt page  Content
class RestarauntPageContent extends StatefulWidget {
  const RestarauntPageContent({Key? key}) : super(key: key);

  @override
  _RestarauntPageContentState createState() => _RestarauntPageContentState();
}

class _RestarauntPageContentState extends State<RestarauntPageContent> {
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
          SizedBox(height: 50),

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
                        print("menu");
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
                      onPressed: () {},
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
    String test =
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
            Text(test),
          ],
        ));
  }
}
