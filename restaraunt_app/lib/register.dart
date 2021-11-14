import 'package:flutter/material.dart';

class register extends StatelessWidget {
  const register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: registerForm(),
    );
  }
}

class registerForm extends StatefulWidget {
  const registerForm({Key? key}) : super(key: key);

  @override
  _registerForm createState() => _registerForm();
}

class _registerForm extends State<registerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
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
                decoration: InputDecoration(labelText: "First Name"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
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
                decoration: InputDecoration(labelText: "Last Name"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
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
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
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
                decoration: InputDecoration(labelText: "Phone Number"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
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
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
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
              ElevatedButton(onPressed: () {}, child: Text("Register"))
            ],
          ),
        ));
  }
}
