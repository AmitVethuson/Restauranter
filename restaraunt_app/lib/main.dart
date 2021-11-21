import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover)),
        child:Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
              //Buttons for Login/Register
              //When clicked users will be routed to their Login/Register page 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Restauranter",
                style: TextStyle(color:Colors.white, fontSize: 50, fontFamily: 'Sora'),
              ),
              Padding(padding: EdgeInsets.only(bottom: 30.0)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => login()));
                  },
                  child: const Text("Login", style:TextStyle(fontFamily: "Sora", color: Colors.black)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shadowColor:  MaterialStateProperty.all<Color>(Colors.black),
                  )),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => register()));
                  },
                  child: const Text("Register", style:TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  )),
            ],
          )
        ),
      )
    );
  }
}
