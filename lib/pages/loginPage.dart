
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_recommend/pages/signupPage.dart';


class LoginScreen extends StatefulWidget {
  final void Function()? onPressed;
  const LoginScreen({super.key,required this.onPressed});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  bool isLoading = false;
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateReEnterPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  signIn() async {
   try {
    setState(() {
      isLoading = true;
    });
await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text
  );
   setState(() {
      isLoading = false;
    });
} on FirebaseAuthException catch (e) {
   setState(() {
      isLoading = false;
    });
  if (e.code == 'user-not-found') {
      return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No user found for that email."),
      )
    ); 
  } else if (e.code == 'wrong-password') {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Wrong password provided for that user."),
      )
    );  }
}
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color:Colors.black), // Set the border color when focused
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color:Colors.black), // Set the border color when not focused
  ),
                    labelText: "Email",
                    fillColor: Colors.white, // Set the background color to white
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Make it circular
                    ),
                        labelStyle: TextStyle(color:Colors.black), // Set label text color to pink

                  ),
                  validator: validateEmail,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color:Colors.black), // Set the border color when focused
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color:Colors.black), // Set the border color when not focused
  ),
                    labelText: "Password",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                        labelStyle: TextStyle(color:Colors.black), // Set label text color to pink

                  ),
                  
                  validator: validatePassword,
                ),
                SizedBox(height: 16.0),
  //               TextFormField(
  //                 controller: reEnterPasswordController,
  //                 obscureText: true,
  //                 decoration: InputDecoration(
  //                    focusedBorder: OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(30.0),
  //   borderSide: BorderSide(color:Colors.black), // Set the border color when focused
  // ),
  // enabledBorder: OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(30.0),
  //   borderSide: BorderSide(color:Colors.black), // Set the border color when not focused
  // ),
  //                   labelText: "Re-enter Password",
  //                   fillColor: Colors.white,
  //                   filled: true,
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(30.0),
  //                   ),
  //                       labelStyle: TextStyle(color:Colors.black), // Set label text color to pink

  //                 ),
  //                 validator: validateReEnterPassword,
  //               ),
           ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0), // Make it circular
    ),
    primary: Colors.black, // Set the button background color to black
  ),
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      signIn();
    }
  },
  child: isLoading
      ? Center(
          child: const CircularProgressIndicator(
            color: Colors.white, // Set the loading indicator color
          ),
        )
      : Text("Sign In", style: TextStyle(fontSize: 18.0)), // Increase font size
),
SizedBox(height: 16.0),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0), // Make it circular
    ),
    primary: Colors.black, // Set the button background color to black
  ),
  onPressed: widget.onPressed,
  child: Text("Sign Up", style: TextStyle(fontSize: 18.0)), // Increase font size
)

              
              ],
            ),
          ),
        ),
      ),
    );
  }
}