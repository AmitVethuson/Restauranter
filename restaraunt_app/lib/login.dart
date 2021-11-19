import 'package:flutter/material.dart';
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

  //input controllers
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
                obscureText: true,
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
        .where('email', isEqualTo:emailController.text)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    if (doc["password"] == passwordController.text) {
    }
  }
}
