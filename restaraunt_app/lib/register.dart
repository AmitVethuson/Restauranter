import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
  final countryController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                          value.isEmpty ||
                          !value.contains("@")) {
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
                          value.isEmpty ||
                          !value.contains("@")) {
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
                          !value.contains("@")) {
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
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: "Phone Number"),
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
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
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
                      onPressed: () {
                        print(firstNameController.text);
                        registerInfo();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => register()));
                      },
                      child: Text("Register"))
                ],
              ),
            )));
  }

  Future<void> registerInfo() {
    return widget.usersRef!.add({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'password': passwordController.text,
      'email': emailController.text,
      'country': "Canada",
      'city': "Toronto",
      'province': "Ontario",
      'phoneNumber': phoneNumberController.text,
      'profilePic': "empty",
    });
  }
}
