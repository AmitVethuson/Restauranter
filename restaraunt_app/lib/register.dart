import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaraunt_app/homepage.dart';
import 'package:restaraunt_app/login.dart';

class register extends StatelessWidget {
  CollectionReference? usersRef;
  register({Key? key, this.usersRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: registerForm(
        usersRef: usersRef,
      ),
    );
  }
}

class registerForm extends StatefulWidget {
  CollectionReference? usersRef;
  registerForm({Key? key, this.usersRef}) : super(key: key);

  @override
  _registerForm createState() => _registerForm();
}

class _registerForm extends State<registerForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  final countryController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  //email text form
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: "First Name"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ) {
                        return "No Input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: "Last Name"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ) {
                        return "No Input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@") || !value.contains(".") ) {
                        return "Invalid email address";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: "Phone Number"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty || value.length !=10) {
                        return "Invalid number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Password is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: reEnterPasswordController,
                    decoration: InputDecoration(labelText: "Re-enter Password"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Password is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    enabled: false,
                    initialValue: 'Canada',
                    decoration: InputDecoration(labelText: "Country"),
                    validator: (value) {},
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //password text form
                  TextFormField(
                    enabled: false,
                    initialValue: 'Ontario',
                    decoration: InputDecoration(labelText: "Province"),
                    validator: (value) {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    enabled: false,
                    initialValue: 'Toronto',
                    decoration: InputDecoration(labelText: "City"),
                    validator: (value) {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async{
                        print(firstNameController.text);  

                        if(_formKey.currentState!.validate()){
                          //check if the database already has a user with the same email address
                          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: emailController.text)
                            .get().catchError((error) => print("Failed to add user: $error"));
                          if(querySnapshot.size != 0){
                            UserAlreadyExists(context);
                          }else{
                            if(passwordController.text != reEnterPasswordController.text){
                              _IncorrectPassword(context);
                            }else{
                              registerInfo(users);
                              Navigator.pop(context);
                              Navigator.push(context,MaterialPageRoute(builder: (context) => login()));
                            }
                          }
                        }
                      },
                      child: Text("Register"))
                ],
              ),
            )));
  }

  _IncorrectPassword(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Password dont match"),
            content: Text("Please make sure the to re-enter the same password."),
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

  UserAlreadyExists(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Already Exists"),
            content: Text("This email is already associated with another account."),
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

  Future<void> registerInfo(CollectionReference users) {
    return users.add({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'password': passwordController.text,
      'email': emailController.text,
      'country': "Canada",
      'city': "Toronto",
      'province': "Ontario",
      'phoneNumber': phoneNumberController.text,
      'profilePic': "empty",
      'isInQueue' : false,
      'isReserved': false,
      'reservation':{
        'restarauntName': 'empty',
        'tableNumber' : 'empty',
        'reservationTime' : 'empty'
      }
    });
  }
}
