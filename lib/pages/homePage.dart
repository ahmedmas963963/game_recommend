import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_recommend/pages/uploadPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[900],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'PS5',
              ),
              Tab(
                text: 'Xbox',
              ),
            ],
            indicatorColor: Colors.white, // Tab indicator color
          ),
          title: Text('Game Library'),
          actions: [
            IconButton(
              icon: Icon(Icons.upload),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UploadGameScreen()),
                );
              },
            )
          ],
        ),
        body: TabBarView(
          children: [
            PS5Screen(),
            XboxScreen(),
          ],
        ),
      ),
    );
  }
}

class PS5Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('games')
          .doc('ps5')
          .collection('games')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pink[900], // Customized progress indicator color
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final games = snapshot.data!.docs;
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            final gameData = game.data() as Map<String, dynamic>;
            return GameCard(
              name: gameData['name'],
              description: gameData['description'],
              imageUrl: gameData['imageUrl'],
            );
          },
        );
      },
    );
  }
}

class XboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('games')
          .doc('xbox')
          .collection('games')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pink[900], // Customized progress indicator color
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final games = snapshot.data!.docs;
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            final gameData = game.data() as Map<String, dynamic>;
            return GameCard(
              name: gameData['name'],
              description: gameData['description'],
              imageUrl: gameData['imageUrl'],
            );
          },
        );
      },
    );
  }
}

class GameCard extends StatefulWidget {
  final String name;
  final String description;
  final String imageUrl;

  GameCard({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpansion,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.imageUrl, // Load the image from the URL
              width: 150, // Set width as needed
              height: isExpanded ? 300 : 250, // Set height as needed
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[900], // Customized text color
                    ),
                  ),
                  isExpanded
                      ? Text(
                          widget.description,
                          style: TextStyle(
                            color: Colors.white, // Customized text color
                          ),
                        )
                      : Container(), // Show description when expanded
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
