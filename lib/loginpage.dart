
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ourpromise/tabpage.dart';
import 'data/userinfo.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isLogin = false;

  Future<void> testSignInWithGoogle() async {

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser userDetails = await _auth.signInWithCredential(credential);
    
    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);

    UserInfoDetails details = new UserInfoDetails(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );

    Provider.of<UserInfomation>(context).details = details;
    
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TabPage()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                  'https://images.unsplash.com/photo-1518050947974-4be8c7469f0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
                  fit: BoxFit.fill,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  colorBlendMode: BlendMode.modulate),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                    width: 250.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                color: Color(0xffffffff),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.google,
                                      color: Color(0xffCE107C),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                    ),
                                  ],
                                ),
                                onPressed : testSignInWithGoogle,                       
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
