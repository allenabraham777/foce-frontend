import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/utils/network_utils.dart';

enum CamState {
  cameraOn,
  cameraOff,
  loadingData
}

enum OptionalState {
  none,
  piece,
  cup
}

class CameraPage extends StatefulWidget {
  CameraPage({this.goBack});
  final VoidCallback goBack;
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CamState camState = CamState.cameraOn;
  OptionalState optionalState = OptionalState.none;
  bool result = false;
  File _image;
  String food, calorie;
  String dropdownValue;
  final TextEditingController _piecesController = new TextEditingController();
  final TextEditingController _bowlsController = new TextEditingController();

  Future getImage() async {
    File image;
    image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800.0,
      maxWidth: 800.0
    );
    setState(() {
      _image = image;
      camState = CamState.cameraOff;
    });
  }

  void callCamera () {
    setState(() {
      _image = null;
      camState = CamState.cameraOn;
    });
  }

  void processdata(BuildContext context) async{
    Prediction pred = new Prediction();
    File image = _image;
    setState(() {
      result = false;
      camState = CamState.loadingData;
    });
    Map res = await pred.predictCalorie(image,piece: _piecesController.value.text, bowl: _bowlsController.value.text);
    print(res);
    if(res["error"] != null) { 
      Navigator.of(context).pop();
      widget.goBack();
    }
    setState(() {
      food = res["food"];
      calorie = res["calorie"];
      result = true;
    });
  }

  List<DropdownMenuItem<String>> listDrop = [
    DropdownMenuItem(
      child: Text(
        "No. of Pieces",
        style: TextStyle(fontSize: 20.0),
      ),
      value: 'pieces'
    ),
    DropdownMenuItem(
      child: Text(
        "No. of Cups",
        style: TextStyle(fontSize: 20.0),
      ),
      value: 'cups'
    ),
    DropdownMenuItem(
      child: Text(
        "None",
        style: TextStyle(fontSize: 20.0),
      ),
      value: 'none'
    )
  ];

  @override
  Widget build(BuildContext context) {
    switch(camState) {
      case CamState.cameraOn: getImage();
        break;
      case CamState.cameraOff: return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(50.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: _image == null ? Container(
                          padding: EdgeInsets.only(top: 80.0),
                          child: Text("Previewing...")
                        ) : Image.file(_image, height: 250.0, width: 250.0)
                      ),
                      SizedBox(height: 20.0),
                      DropdownButton<String>(
                        value : dropdownValue,
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        hint: Text(
                          'Optional - for fast processing',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        items: listDrop,
                        onChanged: (_) {
                          setState(() {
                            _=='pieces' ? optionalState=OptionalState.piece: _=='cups' ? optionalState=OptionalState.cup : optionalState=OptionalState.none;
                            dropdownValue = _;
                          });
                        },
                      ),
                      optionalState != OptionalState.none ? SizedBox(height: 20.0) : SizedBox(height: 0),
                      Container(
                        child: optionalState == OptionalState.piece?
                          TextField(
                            controller: _piecesController,
                            decoration: InputDecoration(
                              labelText: 'No. of Pieces (Optional)',
                              labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green
                                )
                              )
                            ),
                          ): optionalState == OptionalState.cup ?
                          TextField(
                            controller: _bowlsController,
                            decoration: InputDecoration(
                              labelText: 'No. of Bowls (Optional)',
                              labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green
                                )
                              )
                            ),
                          ) :
                          Container()
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              processdata(context);
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.flash_on,
                                  size: 30.0,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Proceed",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.green
                                  )
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 50.0),
                          InkWell(
                            onTap: () {
                              callCamera();
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.refresh,
                                  size: 30.0,
                                  color: Colors.redAccent
                                ),
                                Text(
                                  "Retake",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.redAccent
                                  )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              )
            ),
          ),
        ),
      );
      case CamState.loadingData: 
        return Scaffold(
          body: SafeArea(
            child: Container(
              child: result == true ? Center(
                child: Container(
                  padding: EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Image.file(_image, height: 250.0, width: 250.0),
                      SizedBox(height: 30),
                      Text(
                        food != null ? food.toUpperCase() : "",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        calorie != null ? calorie : "",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 50.0),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Complete"
                        ),
                      )
                    ],
                  ),
                )
              ):Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Calculating",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 24
                      ),
                    ),
                    SizedBox(height: 50),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            ),
          ),
        );
    }
    return Container();
  }
}