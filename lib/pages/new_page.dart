import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:memz/login_page.dart';
import 'package:memz/first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

String placeholderUrl = "https://i.redd.it/pj5kmdqnyb251.png";
String memeUrl = placeholderUrl;
dynamic upvotes = "";
int counter = 0;
String memeTitle = "";
String memeKey = "0";

class _NewPageState extends State<NewPage> {
  void loadNew(bool liked, bool favourited) async {
    final FirebaseUser currentUser = await auth.currentUser();
    userID = currentUser.uid;
    if (memeKey != "0") {
      databaseReference.child("users/$userID/ratings/$memeKey").set(liked);
      if (favourited) {
        databaseReference
            .child("users/$userID/favourites/$memeKey")
            .set(DateTime.now().toUtc().millisecondsSinceEpoch);
      }
    }
    await databaseReference
        .child("users/$userID/counter")
        .once()
        .then((DataSnapshot snapshot) async {
      dynamic data = snapshot.value;
      if (data == null) {
        data = 0;
      }
      data++;
      counter = data;
      await databaseReference
          .child("users/$userID/counter")
          .set(data)
          .then((_s) async {
        await databaseReference
            .child("memes")
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            var data = snapshot.value;
            var keysObj = data.keys;
            var keys = [];
            for (var key in keysObj) {
              keys.add(key);
            }
            memeUrl = data[keys[counter]]["url"];
            upvotes = data[keys[counter]]["ups"];
            memeTitle = data[keys[counter]]["title"];
            memeKey = data[keys[counter]]["id"];
            for (var key in favourites.keys) {
              if (memeKey == key) {
                // loadNew(true, false);
              }
            }
          });
        });
      });
    });
  }

  void getFavourites() {
    databaseReference.child("users/$userID/ratings").once().then((_snap) async {
      favourites = _snap.value;
    });
  }

  var favourites = {};
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    getFavourites();
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Text(
                  memeTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwipeDetector(
                  onSwipeLeft: () {
                    loadNew(false, false);
                  },
                  onSwipeUp: () {
                    loadNew(true, true);
                  },
                  onSwipeRight: () {
                    tabController.animateTo(0);
                  },
                  child: PositionedTapDetector(
                    onDoubleTap: (position) => Share.share(memeUrl),
                    child: CachedNetworkImage(
                      imageUrl: memeUrl,
                      placeholder: (context, url) => Container(
                        child: LinearProgressIndicator(
                          value: 0.001,
                        ),
                        height: 480,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 480,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
