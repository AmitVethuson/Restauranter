import 'package:flutter/material.dart';
import 'package:restaraunt_app/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// @dart=2.9
class login extends StatelessWidget {
  CollectionReference? usersRef;

  login({Key? key, this.usersRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: LoginForm(
        usersRef: usersRef,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  CollectionReference? usersRef;
  LoginForm({Key? key, this.usersRef}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static bool status = false;
  //input controllers
  bool? isVerified;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //sizedbox for spacing
              SizedBox(
                height: 70,
              ),

              //email text form
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    //clear button
                    suffixIcon: IconButton(
                        onPressed: () {
                          emailController.clear();
                        },
                        icon: Icon(Icons.clear))),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Incorrect Email";
                  } else {
                    return null;
                  }
                },
              ),
              //sizedbox for spacing
              SizedBox(
                height: 15,
              ),

              //password text form
              TextFormField(
                controller: passwordController,
                obscureText: false,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    //clear button
                    suffixIcon: IconButton(
                        onPressed: () {
                          passwordController.clear();
                        },
                        icon: Icon(Icons.clear))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Incorrect";
                  } else {
                    return null;
                  }
                },
              ),

              //sizedbox for spacing
              SizedBox(
                height: 20,
              ),

              //login button
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginInfo();
                    }
                  },
                  child: Text("Login"))
            ],
          ),
        ));
  }

  Future<void> loginInfo() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: emailController.text)
        .get()
        .catchError((error) => print("Failed to add user: $error"));
    print(querySnapshot.size);
    if (querySnapshot.size != 0) {
      //When the data exists it will return an array of size 1, else
      //it will bring a size of 0 so when we do the below line it will
      //cause an index error which breaks the code.
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      if (doc["password"] == passwordController.text) {
        //if true then it will go to new page
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));
      } else {
        print("test");
        //if false then add a red text saying something wrong!
        _showAlertDialog(context);
      }
    } else {
      print("test");
      //if false then add a red text saying something wrong!
      status = !status;
      _showAlertDialog(context);
    }
  }

  _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Incorrect Information"),
            content: Text("Email or Password is incorrect please try again"),
            actions: [
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: Text("Close")),
            ],
          );
        });
  }
}
