import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:memz/login_page.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  var memeListThumb = [];
  var keys;
  var allMemes;
  var favouriteMemes = [];
  void getImages() async {
    await databaseReference
        .child("users/$userID/favourites")
        .once()
        .then((DataSnapshot snapshot) async {
      keys = snapshot.value;
      await databaseReference.child("memes").once().then((DataSnapshot snap) {
        setState(() {
          allMemes = snap.value;
          for (var key in keys.keys) {
            var obj = allMemes[key];
            favouriteMemes.add(obj);
          }
          for (var m = 0; m < favouriteMemes.length; m++) {
            memeListThumb.add(favouriteMemes[m]["thumbnail"]);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (memeListThumb.length == 0) {
      getImages();
    }
    return Scaffold(
        body: Container(
      color: Colors.orange,
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(memeListThumb.length, (index) {
          return Center(
            child: CachedNetworkImage(
              height: 140,
              width: 140,
              imageUrl: memeListThumb[index],
            ),
          );
        }),
      ),
    ));
  }
}
