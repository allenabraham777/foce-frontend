import 'package:shared_preferences/shared_preferences.dart';

saveJwt(String jwt) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('jwt', jwt);
}

loadJwt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jwt = prefs.getString('jwt');
  // print(jwt);
  return jwt;
}

checkJwt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool checkValue = prefs.containsKey('jwt');
  // print(checkValue);
  return checkValue;
}