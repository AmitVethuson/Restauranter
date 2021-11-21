import 'package:flutter/material.dart';
import 'package:restaraunt_app/homepage.dart';

class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

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
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  },
                  child: Text("Login"))
            ],
          ),
        ));
  }
}
