
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todomanager/Login/LoginView.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Registartion"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 550,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "User Registration",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                SizedBox(
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border(top: BorderSide(width: 1))),
                  ),
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter your Name",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Email ID",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: contact,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Your Contact Number",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Password",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Confirm Password",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                OutlinedButton(onPressed: () {
                  RegisterUser();
                }, child: Text("Register")),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future RegisterUser() async{
    var email = emailController.text.trim();
    var pass = password.text.trim();
    var Uname = name.text.trim();
    var uContact = contact.text.trim();
    var cPass = confirmPassword.text.trim();

    if(email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Email ID")));
      return;
    }
    if(pass.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Password")));
      return;
    }
    if(pass.length<6){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password must 6 character")));
      return;
    }
    if(Uname.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Name")));
      return;
    }
    if(uContact.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Contact Number")));
      return;
    }
    if(cPass.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Confirm Password")));
      return;
    }
    if(cPass!=pass){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password and Confirm Password must be same.")));
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass
      );
      if(userCredential!=null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Done")));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));

      }
    } on FirebaseAuthException catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User already exists")));

    }
  }
}
