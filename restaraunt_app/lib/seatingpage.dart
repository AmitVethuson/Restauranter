import 'package:flutter/material.dart';

class SeatingPage extends StatefulWidget {
  const SeatingPage({ Key? key }) : super(key: key);

  @override
  _SeatingPageState createState() => _SeatingPageState();
}

class _SeatingPageState extends State<SeatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        title: Text("Seating"),
      
      ),
      body: SeatingPageContent(),
    );
  }
}






class SeatingPageContent extends StatefulWidget {
  const SeatingPageContent({ Key? key }) : super(key: key);

  @override
  _SeatingPageContentState createState() => _SeatingPageContentState();
}

class _SeatingPageContentState extends State<SeatingPageContent> {
  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.blue;
    return GridView.count(crossAxisCount: 2,
    padding: EdgeInsets.all(50),
    children: [
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100,),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100,),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),
      IconButton(onPressed: (){}, icon: Icon(Icons.food_bank_outlined,color: iconColor),iconSize: 100),

    ],
    );
  }
}