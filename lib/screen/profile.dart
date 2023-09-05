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
  //final username=FirebaseAuth.instance.currentUser!._username;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

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
  

// ...

 

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
      final List storedocs=[];
      snapshot.data!.docs.map((DocumentSnapshot document) {
        Map a=document.data() as Map<String,dynamic>;
        
        storedocs.add(a);
      }).toList();

      return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          Column(
            children: [
              Text("username:"),
              Text(storedocs[1]['username']),

            ],
          ),
          
         
          Text(
            'User ID: $uid',
            style: TextStyle(fontSize: 15.0),
          ),
          Row(
            children: [
              Text(
                'mail: $email',
                style: TextStyle(fontSize: 15.0),
              ),
              user!.emailVerified
                  ? Text(
                      'verified',
                      style: TextStyle(fontSize: 9.0, color: Colors.blueGrey),
                    )
                  : TextButton(
                      onPressed: () => {verifyEmail()},
                      child: Text('Verify Email'))
            ],
          ),
          Text(
            'Created: $creationTime',
            style: TextStyle(fontSize: 13.0),
          ),
          ElevatedButton(
  onPressed: () {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification, // Change this to your custom sound
      ios: IosSounds.glass,
      looping: false,
      volume: 1.0,
      asAlarm: true,
    );
  },
  child: Text('Play Custom Ringtone'),
),

        ],
      ),
    );

    },);
    
  }
}