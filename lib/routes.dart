import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/signup.dart';

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  '/signup': (BuildContext context) => new SignupPage(),
  '/home': (BuildContext context) => new HomePage(),
};