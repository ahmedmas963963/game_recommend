import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_recommend/pages/homePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadGameScreen extends StatefulWidget {
  @override
  _UploadGameScreenState createState() => _UploadGameScreenState();
}

class _UploadGameScreenState extends State<UploadGameScreen> {
  String platform = 'ps5'; // default platform
  final nameController = TextEditingController();
  final descController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Upload Game'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: platform,
              onChanged: (newValue) {
                setState(() {
                  platform = newValue!;
                });
              },
              items: <String>['ps5', 'xbox'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Game Name',
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black!),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black!),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                labelStyle: TextStyle(
                    color: Colors.black), // Set label text color to pink
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black!),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black!),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                labelStyle: TextStyle(
                    color: Colors.black), // Set label text color to pink
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Make it round
                ),
                primary:
                    Colors.black, // Set the button background color to black
              ),
              onPressed: _pickImage,
              child: Container(
                width:
                    double.infinity, // Set the width to match the text fields
                child: Center(
                  child:
                      Text('Pick Image', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Make it round
                ),
                primary:
                    Colors.black, // Set the button background color to black
              ),
              onPressed: _uploadGame,
              child: Container(
                width:
                    double.infinity, // Set the width to match the text fields
                child: Center(
                  child: Text('Upload', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            _image != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  void _uploadGame() async {
    // Get data from fields
    String gameName = nameController.text;
    String gameDescription = descController.text;

    // Check if an image is selected
    if (_image == null) {
      // Show an error dialog and return if no image is selected
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Please select an image.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
      return;
    }

    try {
      // Create a reference to the selected platform's "games" subcollection
      CollectionReference gamesCollection = FirebaseFirestore.instance
          .collection('games')
          .doc(platform)
          .collection('games');

      // Upload the image to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('game_images/$gameName.jpg');
      await storageRef.putFile(_image!);

      // Get the URL of the uploaded image
      String imageUrl = await storageRef.getDownloadURL();

      // Add a new document with a unique ID under the "games" subcollection
      await gamesCollection.add({
        'name': gameName,
        'description': gameDescription,
        'imageUrl': imageUrl,
        // Add more data fields as needed
      });

      // Show a success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                Image.file(
                  _image!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text('Game uploaded successfully!'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    } catch (error) {
      print('Error uploading game: $error');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('An error occurred while uploading the game.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }
}
