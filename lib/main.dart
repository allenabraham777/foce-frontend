import 'package:flutter/material.dart';
import 'package:frontend/data/jwt.dart';
import 'package:frontend/rootapp.dart';
import 'package:frontend/routes.dart';
// import 'package:frontend/routes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await loadJwt();
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOCE Frontend',
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RootApp()
    );
  }
}
