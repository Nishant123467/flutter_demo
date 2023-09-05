///import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
//import 'package:speech_recognition/speech_recognition.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screen/usermain.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController voiceInputController = TextEditingController();
  
   //final SpeechRecognition _speechRecognition = SpeechRecognition();
  
  // Declare _isAvailable variable here
  bool _isAvailable = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';
  
  
  

@override
  void initState() {
    super.initState();
    //_speech = stt.SpeechToText();
  }
  
 
  @override
  void dispose() {
   
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  clearText() {
    titleController.clear();
    descriptionController.clear();
  }
 

  Future<void> addTaskToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    final taskData = {
      'title': titleController.text,
    // 'title':Text,
      'description': descriptionController.text,
     // 'voiceInput': _recognizedText,
      'time': FieldValue.serverTimestamp(),
      'isCompleted': false, // Default value
    };

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final taskCollectionRef = userDocRef.collection('tasks');

    await taskCollectionRef.add(taskData);
  }
 

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserMain()),
                  (route) => false,
                );
              },
              child: BackButtonIcon(),
              style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
            ),
            Text("Add Activities"),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
            
              Container(
                 margin: EdgeInsets.symmetric(vertical: 10.0),
                 child: TextFormField(
                   autofocus: false,
                   decoration: InputDecoration(
                     contentPadding: EdgeInsets.all(16.0),
                     labelText: 'Title: ',
                     labelStyle: TextStyle(fontSize: 20.0),
                     border: OutlineInputBorder(),
                     errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                   ),
                   controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Title';
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
                     labelText: 'Description: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                 errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                   ),
                   controller: descriptionController,
                   validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Description';
                     }
                    return null;
                   },
                  ),
                ),

             
            
               Container(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     ElevatedButton(
                      onPressed: () {
                         if (_formKey.currentState!.validate()) {
                           addTaskToFirestore();
                           clearText();
                         }
                       },
                       child: Text(
                        'Add Task',
                        style: TextStyle(fontSize: 18.0),
                      ),
                     ),
                    ElevatedButton(
                      onPressed: clearText,
                       child: Text(
                         'Reset',
                         style: TextStyle(fontSize: 18.0),
                       ),
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                    ),
                   ],
                 ),
               ),
             ],
          ),
        ),
      ),
    );
  }
}
  

















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';
// import 'package:todolist/screen/home.dart';
// import 'package:todolist/screen/usermain.dart';

// class AddTask extends StatefulWidget {
//   const AddTask({super.key});

//   @override
//   State<AddTask> createState() => _AddTaskState();
// }

// class _AddTaskState extends State<AddTask> {

//   final _formKey = GlobalKey<FormState>();

//   var title = "";
//   var description = "";
  
//   // Create a text controller and use it to retrieve the current value
//   // of the TextField.
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
  

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     titleController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   clearText() {
//     titleController.clear();
//     descriptionController.clear();
   
//   }

//   // Adding Task
//   CollectionReference todouser =
//       FirebaseFirestore.instance.collection('todouser');

//   Future<void> Addlist() {
//     return todouser
//         .add({'title': title, 'description': description,'time':FieldValue.serverTimestamp() })
//         .then((value) => print('Task Added'))
//         .catchError((error) => print('Failed to Add task: $error'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
        
//         title: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//            // Text("Welcome User"),
//             ElevatedButton(
//               onPressed: () {
               
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UserMain(),
//                     ),
//                     (route) => false);
//               },
//              child: BackButtonIcon(),
//               style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
//             ),
//             Text("Add Activities"),
//           ],
//         )
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//           child: ListView(
//             children: [
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 10.0),
//                   child: TextFormField(
//                     autofocus: false,
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(16.0),
//                       labelText: 'title: ',
//                       labelStyle: TextStyle(fontSize: 20.0),
//                       border: OutlineInputBorder(),
//                       errorStyle:
//                           TextStyle(color: Colors.redAccent, fontSize: 15),
//                     ),
//                     controller: titleController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Enter title';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 10.0),
//                 child: TextFormField(
//                   autofocus: false,
//                   decoration: InputDecoration(
//                     labelText: 'Description: ',
//                     labelStyle: TextStyle(fontSize: 20.0),
//                     border: OutlineInputBorder(),
//                     errorStyle:
//                         TextStyle(color: Colors.redAccent, fontSize: 15),
//                   ),
//                   controller: descriptionController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please Enter Description';
//                     } 
//                     return null;
//                   },
//                 ),
//               ),
             
//               Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Validate returns true if the form is valid, otherwise false.
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             title = titleController.text;
//                             description = descriptionController.text;
                           
//                             Addlist();
//                             clearText();
//                           });
//                         }
//                       },
//                       child: Text(
//                         'Add Task',
//                         style: TextStyle(fontSize: 18.0),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => {clearText()},
//                       child: Text(
//                         'Reset',
//                         style: TextStyle(fontSize: 18.0),
//                       ),
//                       style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//   final _formKey = GlobalKey<FormState>();
//   var title = "";
//   var description = "";
 
//   TextEditingController titlecontroller=TextEditingController();
//   TextEditingController descriptioncontroller=TextEditingController();
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("New Task"),
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: EdgeInsets.all(20),
        
//         child: Column(
//           children: [
//             Container(
//               child: TextField(
//                 controller: titlecontroller,
//                 decoration: InputDecoration(
//                   labelText: 'Title',
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(borderSide: BorderSide()),),),
//               ),
//               SizedBox(height: 10,),
//               Container(
//               child: TextField(
//                 controller: descriptioncontroller,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Description',
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(borderSide: BorderSide()),),),
//               ),
//                SizedBox(height: 10,),
//               Container(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
                  
//                   onPressed: (){},
//                    style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//               (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.pressed)) return Colors.green;
//                 return Theme.of(context).primaryColor;
//               },
//             ),
//           ),
//                   child: Text('Add Task'),))
            
//           ],
//         )),
//     );
//   }
// }