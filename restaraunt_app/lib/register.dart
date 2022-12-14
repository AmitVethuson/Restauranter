import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      backgroundColor: const Color(0xFFFFF3E0),
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
            padding: const EdgeInsets.all(20),
            child: Form(
              //Text form for registration
              key: _formKey,
              child: Column(
                children: [
                  //email text form
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: "First Name"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ) {
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
                          value.isEmpty ) {
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
                          !value.contains("@") || !value.contains(".") ) {
                        return "Invalid email address";
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
                          value.isEmpty || value.length !=10) {
                        return "Invalid number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Password is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: reEnterPasswordController,
                    decoration: const InputDecoration(labelText: "Re-enter Password"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Password is required";
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
                            //checks user for same password
                            if(passwordController.text != reEnterPasswordController.text){
                              _IncorrectPassword(context);
                            }else{
                              registerInfo(users);
                              Navigator.pop(context);
                              Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
                            }
                          }
                        }
                      },
                      child: const Text("Register"))
                ],
              ),
            )));
  }

  _IncorrectPassword(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Password dont match"),
            content: const Text("Please make sure the to re-enter the same password."),
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

  UserAlreadyExists(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Email Already Exists"),
            content: const Text("This email is already associated with another account."),
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
//register info
  Future<void> registerInfo(CollectionReference users) {
    //When user registers information will be stored in db
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
