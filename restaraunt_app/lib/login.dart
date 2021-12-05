import 'package:flutter/material.dart';
import 'package:restaraunt_app/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db_helper.dart';

class Login extends StatelessWidget {
  CollectionReference? usersRef;

  Login({Key? key, this.usersRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(title: const Text("Login")),
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
  void initState() {
    DBHelper.dbHelper.deleteDB();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //sizedbox for spacing
              const SizedBox(
                height: 70,
              ),

              //email text form
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: const OutlineInputBorder(),
                    //clear button
                    suffixIcon: IconButton(
                        onPressed: () {
                          emailController.clear();
                        },
                        icon: const Icon(Icons.clear))),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Incorrect Email";
                  } else {
                    return null;
                  }
                },
              ),
              //sizedbox for spacing
              const SizedBox(
                height: 15,
              ),

              //password text form
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    //clear button
                    suffixIcon: IconButton(
                        onPressed: () {
                          passwordController.clear();
                        },
                        icon: const Icon(Icons.clear))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Incorrect";
                  } else {
                    return null;
                  }
                },
              ),

              //sizedbox for spacing
              const SizedBox(
                height: 20,
              ),

              //login button
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginInfo();
                    }
                  },
                  child: const Text("Login"))
            ],
          ),
        ));
  }
//Login info 
  Future<void> loginInfo() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: emailController.text)
        .get()
        .catchError((error) => print("Failed to add user: $error"));
    //Checks to see if a response was given(should be =1)
    if (querySnapshot.size != 0) {
      //When the data exists it will return an array of size 1, else
      //it will bring a size of 0 so when we do the below line it will
      //cause an index error which breaks the code.
      //Information sent from firebase db
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      //checks if passwords are correct
      if (doc["password"] == passwordController.text) {
        //Sends information obtained from Firebase DB to sqflite db with insertUserInfo
        int result = await DBHelper.dbHelper.insertUserInfo({
          "city": doc["city"],
          "country": doc["country"],
          "email": doc["email"],
          "firstName": doc["firstName"],
          "lastName": doc["lastName"],
          "password": doc["phoneNumber"],
          "province": doc["province"],
          
        });
        //if true then it will go to new page
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));
      } else {
        //if false then add a red text saying something wrong!
        _showAlertDialog(context);
      }
    } else {
      //if false then add a red text saying something wrong!
      status = !status;
      _showAlertDialog(context);
    }
  }
//Alert dialog is meant to show when an incorrect email or password is inputted 
  _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Incorrect Information"),
            content: const Text("Email or Password is incorrect please try again"),
            actions: [
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: const Text("Close")),
            ],
          );
        });
  }
}
