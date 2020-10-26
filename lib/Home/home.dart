import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   Firestore db=Firestore();
   List<DocumentSnapshot> users;

   @override
  void initState() {
    // TODO: implement initState
     fetchUser();
    super.initState();
  }

  fetchUser() async{
  QuerySnapshot snapshot=await db.collection("user").getDocuments();
  setState(() {
    users=snapshot.documents;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home",style: TextStyle(fontSize: 20),),
      actions: [
        IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
          });

        })
      ],
      ),
      body: Container(
        child: ListView.builder(itemCount: users.length,itemBuilder: (context,index){
          return Container(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text("A"),
                ),
                title: Text(users[index].data()["email"]),
              ),
          );
        }),
      ),
    );
  }
}
