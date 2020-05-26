import 'dart:async';
import 'dart:convert';
import 'package:frontend/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Auth{

  Future<int> attemptLogIn(String username, String password) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    var res = await http.post(
      "$server_url/api/user/login",
      body: {
        "email": username,
        "password": password
      }
    );
    var jwt = res.headers["auth-token"];
    
    
    if(res.statusCode == 200) {
      await prefs.setString('user', json.encode(res.body));
      await prefs.setString('jwt', jwt);
      return res.statusCode;
    }
    return null;
  }

  Future<int> attemptSignUp(String name, String email, String password, String password2) async {
    var res = await http.post(
      '$server_url/api/user/register',
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password2": password2
      }
    );
    return res.statusCode;
    
  }

  Future<bool> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await http.get('$server_url/api/user/logout');
    prefs.remove('jwt');
    prefs.remove('user');
    return true;
  }

  Future<String> currentUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if(prefs.containsKey('jwt') && prefs.containsKey('user')){
      return prefs.getString('jwt');
    }
    else {
      return null;
    }
  }

  Future<Map> currentUserDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if(prefs.containsKey('jwt') && prefs.containsKey('user')){
      return jsonDecode(jsonDecode(prefs.getString('user')).toString());
    }
    else {
      return null;
    }
  }
}