import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_recommend/pages/loginAndSignup.dart';
import 'package:game_recommend/pages/uploadPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => logInAndSignUp()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Recommendations',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: logout, // Call the logout function
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: ColoredTabBar(
              color: Colors.black,
              tabs: [
                Tab(
                  text: 'PS5',
                ),
                Tab(
                  text: 'Xbox',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            PS5Screen(),
            XboxScreen(),
          ],
        ),
        // Add a floating action button
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => UploadGameScreen()),
            );
          },
          tooltip: 'Recommend a Game',
          child: Tooltip(
            message: 'Recommend a Game',
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class ColoredTabBar extends StatelessWidget {
  final Color color;
  final List<Widget> tabs;

  ColoredTabBar({required this.color, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: DefaultTextStyle(
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold), // Adjust text size here
        child: TabBar(
          indicatorColor: Colors.white, // Set the indicator color to pink
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          tabs: tabs,
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
              color: Colors.white, // Customized progress indicator color
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
              color: Colors.white, // Customized progress indicator color
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
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: isExpanded ? 450 : 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                      BorderRadius.circular(12.0), // Add rounded corners
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16, // Adjust the font size
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
