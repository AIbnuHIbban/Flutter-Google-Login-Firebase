import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main(){
  runApp(new MaterialApp(
    title: 'Login Google Firabase',
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  String nama = "";
  String gambar = "";

  Future<FirebaseUser> _signIn()async{
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken
    );

    setState(() {
      nama = user.displayName;
      gambar = user.photoUrl;      
    });
    
    _alertDialog();
  }

  void _alertDialog(){
    AlertDialog alertDialog = new AlertDialog(
      content: new Container(
        height: 200,
        child: ListView(
          children: <Widget>[
            new Text("Sudah login"),
            new Divider(),
            new Image.network(gambar,fit: BoxFit.cover,),
            new Padding(padding: EdgeInsets.only(top:10),),
            new Text(nama,textAlign: TextAlign.center,),
            new Padding(padding: EdgeInsets.only(top:10),),
            new Row(
              children: <Widget>[
                Expanded(
                  child: new RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: ()=> Navigator.pop(context),
                    child: new Text("Ok",style: TextStyle(color: Colors.white),),
                  ),
                ),
                Expanded(
                  child: new RaisedButton(
                    color: Colors.red,
                    child: new Text("Keluar",style: TextStyle(color: Colors.white),),
                    onPressed: ()=>_signOut(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context,child: alertDialog);
  }

  void _signOut(){
    googleSignIn.signOut();
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("Login Google Firebase"),),

      body: Row(        
        children: <Widget>[
          new Expanded(
            child: new RaisedButton(
              child: new Text("Connect With Google",style: TextStyle(color:Colors.white),),
              color: Colors.red,
              elevation: 4,
              splashColor: Colors.white,
              onPressed: ()=> _signIn(),
            ),
          ),
        ],
      ),
    );
  }
}