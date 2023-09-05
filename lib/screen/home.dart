import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:typed_data';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screen/add_task.dart';
import 'package:todolist/screen/edit_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
 // final FirebaseService _firebaseService = FirebaseService();
  String _voiceRecognitionData = '';
  
  String uid='';
  @override
  void initState() {
    
    // TODO: implement initState
    getuid();
    super.initState();
   // _fetchVoiceData();
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // final initializationSettingsIOS = IOSInitializationSettings(requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   requestSoundPermission: false,);
    final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
   // iOS: initializationSettingsIOS,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  getuid()async{
    FirebaseAuth auth=FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
     uid = user.uid;
    print('User UID: $uid');
  }

  }
 

  


  
   bool value = false;

 
  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
      print('task is deleted!');
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }
  Future<void> _scheduleNotification(String taskId, String taskTitle, DateTime notificationTime) async {
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
  'your_channel_id', // Replace with your own channel ID
  'your_channel_name', // Replace with your own channel name
 // 'your_channel_description', // Replace with your own channel description
  importance: Importance.max, // Importance level of the notification
  priority: Priority.high, // Priority level of the notification
  playSound: true, // Play a sound when the notification is displayed
 // sound: RawResourceAndroidNotificationSound('notification_sound'), // Replace with your sound resource
  enableVibration: false, // Enable vibration when the notification is displayed
 // vibrationPattern: Int64List.fromList([2, 100, 200, 300]), // Vibration pattern
 
);
  
  
  final platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  //  iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    taskId.hashCode,
    'please complete your task!',
    taskTitle,
    tz.TZDateTime.from(notificationTime, tz.local),
    platformChannelSpecifics,
    payload: taskId,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
  DateTime now = DateTime.now();
  if (now.isAfter(notificationTime)) {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification, // Change this to your custom sound
      ios: IosSounds.glass,
      looping: false,
      volume: 1.0,
      asAlarm: true,
    );
  }
  // Play the custom ringtone only when the alarm is triggered
  DateTime no = DateTime.now();
  if (no.isAfter(notificationTime)) {
    FlutterRingtonePlayer.playAlarm();
  }
  

}





Future<Map<String, int>> countCompletedTasks(String userId) async {
  final userTasksRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks');
  final userTasksSnapshot = await userTasksRef.get();

  int checkedCount = 0;
  int uncheckedCount = 0;

  for (final taskDoc in userTasksSnapshot.docs) {
    final taskData = taskDoc.data() as Map<String, dynamic>;
    final isCompleted = taskData['isCompleted'] ?? false;

    if (isCompleted) {
      checkedCount++;
    } else {
      uncheckedCount++;
    }
  }

  return {
    'checkedCount': checkedCount,
    'uncheckedCount': uncheckedCount,
  };
}




  @override
  Widget build(BuildContext context) {
    String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp != null) {
      final DateTime dateTime = timestamp.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    }
    return 'Unknown';
  }
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("your task list"),
           ElevatedButton(onPressed: (){ Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTask(),
                    ),
                    (route) => false);}, child: Text("ADD NEW TASK"), style: ElevatedButton.styleFrom(primary: Colors.blueGrey),)
          ],
        ),
      ),
    body: 
     StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks').snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
        if (snapshot.hasError) {
          print("something went wrong");
          
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // final List storedocs=[];
        // snapshot.data!.docs.map((DocumentSnapshot document){
        //   Map a=document.data() as Map<String,dynamic>;
        //   storedocs.add(a);
        //   a['id']=document.id;
        // }).toList();
        final storedocs=snapshot.data!.docs;
       



        return Container(
          
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: ListView.builder(
        itemCount: storedocs.length,
        itemBuilder: (context,index){
       // final docs=storedocs[index];
        

  // Rest of your code...
  final taskData = storedocs[index].data() as Map<String, dynamic>;
        final timestamp = storedocs[index]['time'] as Timestamp?;
        final formattedTime = _formatTimestamp(timestamp);
        bool isCompleted = taskData['isCompleted'] ?? false;
        final taskDoc = storedocs[index];
        final taskId = taskDoc.id;

        return Container(
        
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            
            
            decoration: BoxDecoration(color:Color(0xff121211),
            borderRadius:BorderRadius.circular(10)), 
            height: 90,
            child: Row(
               
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: [
                SizedBox(width: 1.0,),
                Container(
                 constraints: BoxConstraints.tightFor(width: 22.0, height: 22.0), // Set the checkbox size
                 color: Colors.green,
                 padding: EdgeInsets.all(0.0), 
                 child: Checkbox(
  value: storedocs[index]['isCompleted'] ?? false,
  onChanged: (bool? newValue) async {
    if (newValue != null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final taskDocId = storedocs[index].id;

      // Update 'isCompleted' in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskDocId)
          .update({'isCompleted': newValue});

      setState(() {
       isCompleted = newValue;
      });

      // Call the countCompletedTasks function to get updated counts
      // final counts = await countCompletedTasks(userId);
      // print('Checked tasks: ${counts['checkedCount']}');
      // print('Unchecked tasks: ${counts['uncheckedCount']}');
    }
  },
  activeColor: Colors.blue,
),

                ),
                Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                    SizedBox(
                                   width: 10,
                                ),
                    Container( margin: EdgeInsets.only(left: 20),
                    child: Wrap(
                      children: [
                        //  Container(child: print(taskData['title']),),
                        Text(
                   //   _voiceRecognitionData,
                              taskData['title'] , // Use 'title' from your document
                              style: TextStyle(color: Colors.white),
                            ),
                      ],
                    ),
                    //child: Text("this is title row",style: TextStyle(color: Colors.white),),
                    ),
                     SizedBox(
                                   height: 10,
                                ),
                                Container(
                                   margin: EdgeInsets.only(left: 20),
                                    child: Expanded(
                                      child: Text(
                                       formattedTime
                                                                , // Use 'time' from your document
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                    ),
                                  // child: Text("this is time row",style: TextStyle(color: Colors.white),)

                                )

                   ],

                ),
                SizedBox(width: 10,),

               
                 Container(
                //  margin: EdgeInsets.only(left: 10),
                child: IconButton(onPressed: ()async{
                    final userId = FirebaseAuth.instance.currentUser!.uid;
                 final counts = await countCompletedTasks(userId);
      print('Checked tasks: ${counts['checkedCount']}');
     print('Unchecked tasks: ${counts['uncheckedCount']}');
                //  deleteUser(docs['id']);
              deleteTask(taskId);

                  }, icon: Icon(Icons.delete,color: Colors.red,))
            ),
            Container(
  child: IconButton(
    onPressed: () {
      // Show a time picker when the button is pressed
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ).then((pickedTime) {
        if (pickedTime != null) {
          // Convert the TimeOfDay to a DateTime
          final now = DateTime.now();
          final notificationTime = DateTime(
            now.year,
            now.month,
            now.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // Schedule a notification
          _scheduleNotification(taskId, taskData['title'], notificationTime);
        }
      });
    },
    icon: Icon(Icons.alarm_add,color: Colors.green,),
  ),
),
Container(
  child: IconButton(onPressed: ()=>{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>updatetask(id:taskId),),)
  }, icon: Icon(Icons.edit,color: Colors.white,)),

)

             
            


              ],
              

            ),),

          );
        }

        ),
        );
      },),
      );
  }
}
    