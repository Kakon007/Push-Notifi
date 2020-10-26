import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/Home/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth firebaseAuth= FirebaseAuth.instance;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  FirebaseMessaging firebaseMessaging= FirebaseMessaging();
  FirebaseFirestore  db=FirebaseFirestore .instance;

  @override
  void initState() {
    // TODO: implement initState
    CheckUserAuth();
    super.initState();
  }

  CheckUserAuth() async{
   try{
     FirebaseUser user= await firebaseAuth.currentUser as FirebaseUser;
     if(user != null){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
     }
   }catch(e){
     print(e);
   }
  }


  signIn() async {

    String email=emailController.text;
    String password=passwordController.text;
    if(email.isNotEmpty && password.isNotEmpty){
      // AuthResult result= firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) async{
      //   //String fcmtoken= await firebaseMessaging.getToken();
      //   FirebaseUser user=.user ;
      //
      //
      //   db.collection("user").document(user.uid).setData({
      //     "email" : user.email,
      //     //"fcmToken" : fcmtoken,
      //   });
      //
      //   //to topic
      //   firebaseMessaging.subscribeToTopic("promotion");
      //   firebaseMessaging.subscribeToTopic("news");
      //
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      // } );

      final User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
          password: password,
      )).user;

      String fcmtoken= await firebaseMessaging.getToken();


      db.collection("user").document(user.uid).setData({
        'email' : user.email,
        'fcmToken' : fcmtoken,
      });

      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    }else{
     print("Enter Valid Email And PassWord");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(8),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  labelText: "Email"

              ),
              keyboardType: TextInputType.emailAddress,
            ),
            ),

            SizedBox(height: 20,),

            Padding(padding: EdgeInsets.all(8),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  labelText: "Password"

              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,

            ),
            ),



            SizedBox(height: 20,),

            RaisedButton(onPressed: (){
              // firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then<void>((value) async{
              //
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              // });
              signIn();
            },
            child: Text("Signin"),
            )

          ],
        ),
      ),
    );
  }
}
