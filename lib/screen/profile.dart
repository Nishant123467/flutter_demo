import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Stream<QuerySnapshot>userStream=FirebaseFirestore.instance.collection('users').snapshots();
  





  final uid = FirebaseAuth.instance.currentUser!.uid;
  
  final email = FirebaseAuth.instance.currentUser!.email;
  //final username=FirebaseAuth.instance.currentUser!.username;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;
  String? username;
  

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Verification Email has benn sent',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
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


    return StreamBuilder<QuerySnapshot>(stream: userStream,builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot ){
      if(snapshot.hasError)
      {
        print("something went wrong");
        }
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return Center(
        child: CircularProgressIndicator(),
      );
      }
     
     
     // final username = userData['username'];
     

      final List storedocs=[];
      snapshot.data!.docs.map((DocumentSnapshot document) {
        Map a=document.data() as Map<String,dynamic>;
        
        storedocs.add(a);
        if (document.id == uid) {
            username = a['username'];
          }
      }).toList();

      return Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/simple.png"),
         fit: BoxFit.cover,),),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
           Image.asset('assets/images/profile.webp',
                  height: 200,
                  scale: 2.5,
                  // color: Color.fromARGB(255, 15, 147, 59),
                  opacity:
                      const AlwaysStoppedAnimation<double>(0.5)),
          
          Row(
            children: [
              Container(child: Icon(Icons.person)),
              
                 
              Container(child: Text(' Username: ${username ?? "N/A"}')),
            ],
          ),
          Row(
            children: [
              SizedBox(height: 10,)
            ],
          ),
           
           Row(
            children: [
              Icon(Icons.email),
              Text(
                'mail: $email',
                style: TextStyle(fontSize: 15.0),
              ),
              // user!.emailVerified
              //     ? Text(
              //         'verified',
              //         style: TextStyle(fontSize: 9.0, color: Colors.blueGrey),
              //       )
              //     : TextButton(
              //         onPressed: () => {verifyEmail()},
              //         child: Text('Verify Email'))
            ],
          ),
           Row(
            children: [
              Container(child: Icon(Icons.verified_user)),
              
                  user!.emailVerified
                  ? Text(
                      'verified Email',
                      style: TextStyle(fontSize: 9.0, color: Colors.blueGrey),
                    )
                  : TextButton(
                      onPressed: () => {verifyEmail()},
                      child: Text('Verify Email'))
              
            ],
          ),
           
          
           Row(
            children: [
              Container(child: Icon(Icons.verified_user)),
              
                 
              Container(child: Text(
            'User ID: $uid',
            style: TextStyle(fontSize: 15.0),
          ),),
            ],
          ),
          Row(
            children: [
              SizedBox(height: 10,)
            ],
          ),
         
          Row(
            children: [
              Container(child: Icon(Icons.create_rounded)),
              
                 
              Text(
            'Created: $creationTime',
            style: TextStyle(fontSize: 13.0),
          ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("YOUR TASK STATUS",style: TextStyle(color: Colors.black,fontSize: 25),)
            ],
          ),
          SizedBox(height: 3,),
          Row(
            children: [
              Container(
                child: FutureBuilder<Map<String, int>>(
  future: countCompletedTasks(uid), // Call the function with the user ID.
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Display a loading indicator while fetching data.
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (!snapshot.hasData) {
      return Text('No data available.');
    } else {
      // Data is available, extract the counts.
      int checkedCount = snapshot.data!['checkedCount'] ?? 0;
      int uncheckedCount = snapshot.data!['uncheckedCount'] ?? 0;

      // Display the counts.
      return Column(
        children: [
          Text('complete task: $checkedCount',style: TextStyle(color: Colors.blue,fontSize: 17),),
          SizedBox(height: 3,),
          Text('pending task: $uncheckedCount',style: TextStyle(color: Colors.red,fontSize: 17),),
        ],
      );
    }
  },
)
,
                // final userId = FirebaseAuth.instance.currentUser!.uid;
                
                    //  margin: EdgeInsets.only(left: 10),
                   
                ),
            ],
          ),
        
        
        
//           ElevatedButton(
//   onPressed: () {
//     FlutterRingtonePlayer.play(
//       android: AndroidSounds.notification, // Change this to your custom sound
//       ios: IosSounds.glass,
//       looping: false,
//       volume: 1.0,
//       asAlarm: true,
//     );
//   },
//   child: Text('Play Custom Ringtone'),
// ),

        ],
      ),
    );

    },);
    
  }
}