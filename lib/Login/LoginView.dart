import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todomanager/Home/HomeVieew.dart';
import 'package:todomanager/Registration/Registration.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 350,
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
                  "Login Pannel",
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
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                    labelText: "Enter Email ID",
                  ),
                  validator: (text){
                    if(text==null || text.isEmpty){
                      setState(() {

                      });
                      return "Enter Email ID";

                    }
                    return  null;
                  },

                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: passwordController,
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
              OutlinedButton(
                  onPressed: () {
                    SignIn();
                  },
                  child: Text("Submit")),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Registration()));
                    },
                    child: Text("Don't have Account?"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future SignIn() async {

    var email = emailController.text.trim();
    var pass = passwordController.text.trim();
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
    var sh = showDialog(
        context: context, barrierDismissible: false, builder: (context) {
      return Center(child: CircularProgressIndicator());
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass);
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeView()));
    } on FirebaseAuthException catch(e){
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid User Id and Pass")));

    }
  }
}
