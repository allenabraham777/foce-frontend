import 'dart:convert';
import 'dart:io';
import 'package:frontend/config/config.dart';
import 'package:frontend/utils/auth.dart';
import 'package:http/http.dart' as http;

class Prediction {
  Future <Map> predictCalorie(File image, {String piece, String bowl}) async {
    Auth auth = new Auth();
    String token = await auth.currentUserToken();
    String base64Image = "";
    if(image != null){
      base64Image = base64Encode(image.readAsBytesSync());
    }
    var res = await http.post(
      '$server_url/api/prediction',
      headers: {"auth-token": token},
      body: {
        "image": base64Image,
        "piece": piece != null ? piece : "" ,
        "bowl": bowl != null ? bowl : ""
      }
    );
    print(res.body);
    return jsonDecode(res.body);
  }
}