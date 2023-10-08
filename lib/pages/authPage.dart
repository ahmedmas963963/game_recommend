import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_recommend/pages/homePage.dart';
import 'package:game_recommend/pages/loginAndSignup.dart';
import 'package:game_recommend/pages/loginPage.dart';

class authPage extends StatelessWidget {
  const authPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,AsyncSnapshot<User?> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          else
          {
            if(snapshot.hasData){
              return HomeScreen();
            }
            else{
              return logInAndSignUp();
            }
        
        }},
      ),
    );
  }
}