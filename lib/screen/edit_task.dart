import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class updatetask extends StatefulWidget {
  final String id;
  updatetask({Key? key, required this.id}) : super(key: key);
  //const updatetask({super.key});

  @override
  State<updatetask> createState() => _updatetaskState();
}

class _updatetaskState extends State<updatetask> {
  //final _formKey=GlobalKey<FormState>;
  void updateTask(String userId,String  taskId, Map<String, dynamic> updatedData) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update(updatedData);
    print('Task updated successfully');
  } catch (e) {
    print('Error updating task: $e');
  }
}
String userId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("update task!"),
      ),
      body: Form(child: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(future:FirebaseFirestore.instance.collection('users')
      .doc(userId)
      .collection('tasks')
      .doc(widget.id) 
      .get(),
      builder: (_, snapshot){
        if(snapshot.hasError)
        {
          print("something went wrong");
        }
        if (snapshot.connectionState==ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
          
        }
        var data=snapshot.data!.data();
        var title=data!['title'];
        return
      
       Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/simple.png"),
        fit: BoxFit.cover,),),
         child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                    children: [
                      Container(
                        
                         margin: EdgeInsets.symmetric(vertical: 10.0),
                         child: TextFormField(
                           initialValue: title,
                          autofocus: false,
                          onChanged: (value) => title=value,
                           decoration: InputDecoration(
                            labelText: 'title:',
                            labelStyle: TextStyle(fontSize: 20.0),
                            border: OutlineInputBorder(),
                            errorStyle:
                                TextStyle(color: Colors.redAccent, fontSize: 15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter title';
                          }
                            return null;
                          },
                        ),
                      ),
            
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                    // Container(
                      //   margin: EdgeInsets.symmetric(vertical: 10.0),
                      //   child: TextFormField(
                       //     initialValue: password,
                       //     autofocus: false,
                       //     onChanged: (value) => password = value,
                       //     obscureText: true,
                       //     decoration: InputDecoration(
                       //       labelText: 'Password: ',
                      //       labelStyle: TextStyle(fontSize: 20.0),
                       //       border: OutlineInputBorder(),
                      //       errorStyle:
                       //           TextStyle(color: Colors.redAccent, fontSize: 15),
                      //     ),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                    //         return 'Please Enter Password';
                      //       }
                      //       return null;
                      //     },
                       //   ),
                      // ),
                       Container(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Map<String, dynamic> updatedData = {
             'title': title, // Update with other fields if needed
           };
                              updateTask(userId, widget.id, updatedData);
                               },
                               child: Text(
                                 'Update task',
                               style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => {},
                              child: Text(
                                'Reset',
                               style: TextStyle(fontSize: 18.0),
                             ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey),
                            ),
                         ],
                        ),
                      )
                    ],
                ),
                ),
       );
      }
      ),
    )
    );

            }
          
    
    
  }
