import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaraunt_app/homepage.dart';
import 'package:restaraunt_app/login.dart';

class Register extends StatelessWidget {
  CollectionReference? usersRef;
  Register({Key? key, this.usersRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: RegisterForm(
        usersRef: usersRef,
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  CollectionReference? usersRef;
  RegisterForm({Key? key, this.usersRef}) : super(key: key);

  @override
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final countryController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  //email text form
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: "First Name"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "No Input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: "Last Name"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "No Input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "No Input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "No Input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "No Input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    enabled: false,
                    initialValue: 'Canada',
                    decoration: const InputDecoration(labelText: "Country"),
                    validator: (value) {},
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //password text form
                  TextFormField(
                    enabled: false,
                    initialValue: 'Ontario',
                    decoration: const InputDecoration(labelText: "Province"),
                    validator: (value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    enabled: false,
                    initialValue: 'Toronto',
                    decoration: const InputDecoration(labelText: "City"),
                    validator: (value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(firstNameController.text);
                        registerInfo(users);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()));
                      },
                      child: const Text("Register"))
                ],
              ),
            )));
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
