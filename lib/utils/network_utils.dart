import 'dart:convert';
import 'dart:io';
import 'package:frontend/config/config.dart';
import 'package:frontend/utils/auth.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class Prediction {
  Future <Map> predictCalorie(File image, {String piece, String bowl}) async {
    Auth auth = new Auth();
    String token = await auth.currentUserToken();
    // String base64Image = "";
    // if(image != null){
    //   base64Image = base64Encode(image.readAsBytesSync());
    // }
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // get file length
    var length = await image.length();
    
    print("Piece : $piece");
    print("Bowl : $bowl");

    var uri = Uri.parse('$server_url/api/prediction');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({"auth-token": token});
    request.fields.addAll({
      "piece" : piece,
      "bowl" : bowl
    });
    request.files.add(http.MultipartFile('image', stream, length, filename: "image"));
                  // ..fields['user'] = 'nweiz@google.com'
                  // ..files.add(http.MultipartFile('file', stream, length,
                  //       filename: basename(image.path)));
  var res = await request.send();
  if (res.statusCode == 200) {
    var r = await res.stream.bytesToString();
    return jsonDecode(r);
    // print(r);
  }
  if (res.statusCode >= 400 && res.statusCode < 500) {
    auth.logOut();
    return {"error" : "Access Denied"};
    // print(r);
  }
    
    // var res = await http.post(
    //   '$server_url/api/prediction',
    //   headers: {"auth-token": token},
    //   body: {
    //     "image": base64Image,
    //     "piece": piece != null ? piece : "" ,
    //     "bowl": bowl != null ? bowl : ""
    //   }
    // );
    
    print(res.stream);
    return {"food": "Error", "calorie": "Error"};
  }
}