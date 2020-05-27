import 'package:flutter/material.dart';
import 'package:frontend/screens/camera.dart';
import 'package:frontend/utils/auth.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Auth auth = new Auth();
  Map userDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth.currentUserDetails().then((Map details) {
      if(details != null){
        setState(() {
         userDetails = details;
        });
      }
      else
        widget.onSignedOut();
    });
  }

  void showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed:  () {
        widget.onSignedOut();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logging Out"),
      content: Text("Would you like to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
            },
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {showAlertDialog(context);},
            child: Icon(Icons.exit_to_app),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text(
                userDetails!= null ? userDetails['name'] : "",
                style: new TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              accountEmail: new Text(
                userDetails!= null ? userDetails['email'] : "",
                style: new TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w500),
              )
            )
          ],
        ),
      ),
      body: Center(
        child: Text("Hi There,")
      ),
    );
  }
}