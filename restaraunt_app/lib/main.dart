import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Reservation',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//Initial page of our application for login/register
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

              const Padding(padding: EdgeInsets.only(bottom: 30.0)),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    
                    //Directs user to login.dart page

                      context, MaterialPageRoute(builder: (context) => Login()));
                },
                child: const Text("Login", style:TextStyle(fontFamily: "Sora", color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(width: 1.0),
                  primary: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 2.0
                )),

              const Padding(padding: EdgeInsets.only(bottom: 10.0)),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    //Directs user to register.dart page
                      context, MaterialPageRoute(builder: (context) => Register()));
                },
                child: const Text("Register", style:TextStyle(color: Colors.black)),
                
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(width: 1.0),
                  primary: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 2.0
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}
