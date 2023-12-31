import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  var confirmPassword = "";
  var _username = '';
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernamecontroller=TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

   registration() async {
     if (password == confirmPassword) {
       try {
         UserCredential userCredential = await FirebaseAuth.instance
             .createUserWithEmailAndPassword(email: email, password: password);

              // Get the currently authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Store additional user data (username) in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _username,
          'email':email,
          'password':password,
        });

        print('Signup successful: Email: $email, Username: $_username');
      }
         print(userCredential);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             backgroundColor: Colors.blue,
             content: Text(
               "Registered Successfully. Please Login..",
               style: TextStyle(fontSize: 20.0),
             ),
          ),
         );
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (context) => Login(),
          ),
         );
       } on FirebaseAuthException catch (e) {
         if (e.code == 'weak-password') {
           print("Password Provided is too Weak");
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               backgroundColor: Colors.orangeAccent,
              content: Text(
                 "Password Provided is too Weak",
                 style: TextStyle(fontSize: 18.0, color: Colors.black),
             ),
           ),
         );
       } else if (e.code == 'email-already-in-use') {
          print("Account Already exists");
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               backgroundColor: Colors.orangeAccent,
               content: Text(
                 "Account Already exists",
                 style: TextStyle(fontSize: 18.0, color: Colors.black),
               ),
             ),
        );
         }
       }
     } else {
       print("Password and Confirm Password doesn't match");
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           backgroundColor: Colors.orangeAccent,
           content: Text(
             "Password and Confirm Password doesn't match",
             style: TextStyle(fontSize: 16.0, color: Colors.black),
           ),
         ),
       );
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User SignUp"),
      ),
      body: Container(
       decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/simple.png"),
        fit: BoxFit.cover)),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              
              children: [
                Container(
                  child: Image.asset("assets/images/to.jpg"),
                ),
                SizedBox(height: 20,),
      Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'username: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: usernamecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter name';
                      } 
                      return null;
                    },
                  ),
                ),
      
      
      
      
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Email: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      } else if (!value.contains('@')) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                              confirmPassword = confirmPasswordController.text;
                              _username=usernamecontroller.text;
      
                            });
                            registration();
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an Account? "),
                      TextButton(
                          onPressed: () => {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            Login(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                )
                              },
                          child: Text('Login'))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

