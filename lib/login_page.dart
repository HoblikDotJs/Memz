import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memz/sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String userID;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    void pr() async {
      final FirebaseUser currentUser = await auth.currentUser();
      if (currentUser != null) {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Profile();
              },
            ),
          );
        });
      }
    }

    pr();
    getInfo();
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // AssetImage("icon/icon.png")
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Profile();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future getInfo() async {
  final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signInSilently();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final AuthResult authResult = await auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await auth.currentUser();
  assert(user.uid == currentUser.uid);
  userID = user.uid;
  // print("__________________________");
  // print(name);
  // print(email);
  // print(imageUrl);
  return;
}
