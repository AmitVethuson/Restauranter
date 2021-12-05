import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}
//Menu Pages
class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
      ),
      //listview of menu items
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Text('Starters',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                  ))),
          // add starter menu items to listview
          createContainer(
              "Garlic Escargot",
              "Topped with mozzarella and parmesan served with garlic toast.",
              "\$14.99"),
          createContainer("Teriyaki Ribs", "Served with dill dip.", "\$14.99"),
          createContainer("Crispy Chicken Wings (8pc)",
              "Teriyaki, honey garlic, hot, or lemon pepper.", "\$14.99"),
          createContainer("Potato Skins.",
              "Loaded with green onions, bacon and cheddar.", "\$14.99"),
          createContainer("Deep Fried Perogies (8pc)",
              "Served with sweet chili sauce.", "\$14.99"),
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Text('Entrees',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                  ))),
          // add entrees menu items to listview
          createContainer("Danish Baby Back Pork Rum Ribs - Full",
              "Delicious with thick rum Sauce.", "\$23.99"),
          createContainer("Lemon Chicken",
              "Creamy sauce with mushrooms and parmesan.", "\$19.99"),
          createContainer("Liver 'n Onions - Large (2pc)",
              "Topped with grilled onions and gravy.", "\$21.99"),
          createContainer("Veal Parmesan - Large (2pc)",
              "Topped with zesty Italian sauce and cheese.", "\$21.99"),
          createContainer("Salmon Fillet",
              "Baked with seasonings and white wine.", "\$19.99"),
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Text('Other Choices',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                  ))),
          // add Other Choices menu items to listview
          createContainer("Steak Sandwhich - 8oz",
              "Served on garlic toast with house salad and fries.", "\$19.99"),
          createContainer("Fish 'n Chips",
              "Served with coleslaw and tartar sauce.", "\$18.99"),
          createContainer(
              "Chicken Dinner",
              "3 pieces of chicken fried golden brown, served with fries",
              "\$18.99"),
          createContainer("Chicken Fingers - Large (3pc)",
              "With fries and plum sauce", "\$15.25"),
        ],
      ),
    );
  }
}

//MenuItem Containter Tile
Widget createContainer(String menuItem, String menuDescprition, String price) {
  return ListTile(
    title: Text(menuItem),
    subtitle: Text(menuDescprition),
    trailing: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(price),
      ],
    ),
  );
}
