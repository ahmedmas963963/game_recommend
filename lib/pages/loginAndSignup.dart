import 'package:flutter/material.dart';
import 'package:game_recommend/pages/loginPage.dart';
import 'package:game_recommend/pages/signupPage.dart';

class logInAndSignUp extends StatefulWidget {
  
  const logInAndSignUp({super.key});

  @override
  State<logInAndSignUp> createState() => _logInAndSignUpState();
}

class _logInAndSignUpState extends State<logInAndSignUp> {
  bool isLogin = true;
  void togglePage(){
    setState(() {
          isLogin = !isLogin;

    });
  }
  @override
  Widget build(BuildContext context) {
   if (isLogin){
    return LoginScreen(
      onPressed: togglePage
    );
   }
   else{
    return SignUpScreen(
      onPressed:togglePage
    );
   }
  }
}