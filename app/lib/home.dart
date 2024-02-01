import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pest_app/AddRecordComponents/qr.dart';
import 'package:pest_app/add_crop_category.dart';
import 'package:pest_app/locationmap.dart';
import 'package:dio/dio.dart';
import 'package:pest_app/login.dart';
import 'package:pest_app/model.dart';
import 'package:pest_app/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> CropsList = [];

  @override
  bool isListLoaded = false;
  void initState() {
    super.initState();
    // ignore: avoid_print
    print("initState Called");
    // startAutoReload();

    getCrops();
  }

  @override
  void autoReload() {
    getCrops();
    // setState(() {
    //   _countOfReload = _countOfReload + 1;
    // });
  }

  getCrops() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('userLoggedIn', true);
    print(prefs.getBool('userLoggedIn'));
    var dio = Dio();
    final res = await dio.get(url + '/api/addcategory/');

    setState(() {
      // List<CropsModel> crops = (json.decode(res.data))
      //     .map((data) => CropsModel.fromJson(data))
      //     .toList();
      // List jsonResponse = json.decode(res.data);

      // CropsModel crops = CropsModel.fromJson(jsonResponse[0]);
      //   if (res.statusCode == 200) {
      //   return CropsModel.fromJson(response.body);
      // } else {
      //   throw Exception('Request Failed.');
      // }
      // var crops = CropsModel.fromJson(res.data);
      // List<Map> myProducts = [];
      for (var i in res.data) {
        print(i);
        // listc.add(
        //   CropsModel.fromJson(json.decode(i)),
        // );
        CropsList.add({
          "id": i["uid"],
          "crop_name": i["crop_name"],
          "crop_description": i["crop_description"],
          "crop_type": i["crop_type"],
          "latitude": i["latitude"],
          'longitude': i["longitude"]
        });
      }

      isListLoaded = true;
      print(CropsList);
    });

    // return res;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setBool('userLoggedIn', false);
            print(prefs.getBool('userLoggedIn'));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 56, 193, 113),
      ),
      body: isListLoaded
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            "Crops",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    CropsList = [];
                                  });
                                  getCrops();
                                },
                                icon: Icon(Icons.refresh)),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddCropCategory()),
                                  );
                                },
                                icon: Icon(Icons.add)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      // height: 400,
                      // child: GridView.builder(
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 3,
                      //   ),
                      //   itemBuilder: (BuildContext ctx, index) {
                      //     Container(
                      //       width: double.infinity,
                      //       margin: EdgeInsets.all(10),
                      //       color: Colors.grey,
                      //       child: Center(
                      //         child: Text(
                      //           "Crop A",
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      child: SingleChildScrollView(
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: CropsList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(10),
                              color: Colors.grey,
                              child: Center(
                                child: Text(
                                  CropsList[index]["crop_name"],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // GridView(
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.vertical,
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3,
                    //   ),
                    //   children: [
                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.all(10),
                    //   color: Colors.grey,
                    //   child: Center(
                    //     child: Text(
                    //       "Crop A",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    //     Container(
                    //       width: double.infinity,
                    //       margin: EdgeInsets.all(10),
                    //       color: Colors.grey,
                    //       child: Center(
                    //         child: Text(
                    //           "Crop B",
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       width: double.infinity,
                    //       margin: EdgeInsets.all(10),
                    //       color: Colors.grey,
                    //       child: Center(
                    //         child: Text(
                    //           "Crop C",
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       width: double.infinity,
                    //       margin: EdgeInsets.all(10),
                    //       color: Colors.grey,
                    //       child: Center(
                    //         child: Text(
                    //           "Crop D",
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QRWidget()),
                          );
                        },
                        child: Text(
                          'Add New Record',
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
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // const url = '192.168.0.127:8000/api/dl';
                          // final Uri uri = Uri(scheme: 'http', host: url);
                          // if (!await launchUrl(uri,
                          //     mode: LaunchMode.externalApplication)) {
                          //   throw "Can't Connect to Host.";
                          // }
                          launchUrl(Uri.parse(url + "/api/dl"),
                              mode: LaunchMode.externalApplication);
                        },
                        child: Text(
                          'Download Dataset (.zip)',
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
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
