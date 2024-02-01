import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pest_app/home.dart';
import 'package:pest_app/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTrap extends StatefulWidget {
  AddTrap(
      {super.key,
      required File this.leaf,
      required String this.qr,
      required String this.crop});
  File leaf;
  String qr;
  String crop;
  @override
  State<AddTrap> createState() => _AddTrapState();
}

postData(qr, leaf, trap, crop) async {
  var leafContent = leaf.readAsBytesSync();
  var leafContentBase64 = base64.encode(leafContent);
  var trapContent = trap.readAsBytesSync();
  var trapContentBase64 = base64.encode(trapContent);
  // var response = http.post(
  //   Uri.parse('http://192.168.0.127:8000/api/addsample/'),
  //   // headers: <String, String>{
  //   //   'Content-Type': 'application/json; charset=UTF-8',
  //   // },
  //   body: {
  //     'qr': qr,
  //     'leaf': [leafContentBase64],
  //     'trap': [trapContentBase64]
  //   },
  // );
  // var request = http.MultipartRequest(
  //     'POST', Uri.parse('http://192.168.0.127:8000/api/addsample/'));
  // request.fields['qr'] = json.encode(qr);
  // request.files.add(http.MultipartFile.fromBytes(
  //     'leaf', File(leaf).readAsBytesSync(),
  //     filename: leaf.split("/").last));
  // request.files.add(http.MultipartFile.fromBytes(
  //     'trap', File(trap).readAsBytesSync(),
  //     filename: trap.split("/").last));
  final dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print(position.latitude + position.longitude);
  final formData = FormData.fromMap({
    'qr': qr,
    'crop': crop,
    'leaf': await MultipartFile.fromBytes(leafContent, filename: 'image.jpg'),
    'trap': await MultipartFile.fromBytes(trapContent, filename: 'trap.jpg'),
    'user': prefs.getString('username'),
    'latitude': position.latitude ?? 0,
    'longitude': position.longitude ?? 0
  });
  final response = await dio.post(url + '/api/addsample/', data: formData);

  return response;
}

class _AddTrapState extends State<AddTrap> {
  late File imgPath;
  bool isLoaded = false;
  bool isPosted = false;
  late File image;

  Future<void> loadCamera() async {
    final imagepicker = ImagePicker();
    var img = await imagepicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 50,
    );

    if (img == null) {
      return null;
    } else {
      image = File(img.path);
      setState(
        () {
          imgPath = image;
          isLoaded = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isPosted
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "Add Trap Image",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 56, 193, 113),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => loadCamera(),
                        child: Text(
                          'Select Trap Image',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 56, 193, 113),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(25),
                      child: isLoaded
                          ? Image.file(
                              imgPath,
                              fit: BoxFit.fill,
                            )
                          : SizedBox(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 50,
                      child: isLoaded
                          ? ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isPosted = true;
                                });

                                //new change
                                Fluttertoast.showToast(
                                  msg: "Uploaded Successfully ✅",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                );
                                var res = await postData(
                                    widget.qr, widget.leaf, image, widget.crop);
                                res.data["success"] == 1
                                    ? Fluttertoast.showToast(
                                        msg:
                                            "Uploaded Successfully Sample of " +
                                                res.data["Pest"].toString() +
                                                "✅",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0)
                                    : Fluttertoast.showToast(
                                        msg: "Something Went Wrong ❌",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                print(res);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Home()),
                                // );
                              },
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 56, 193, 113),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
