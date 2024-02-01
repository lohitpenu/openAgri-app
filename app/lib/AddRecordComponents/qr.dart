import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pest_app/AddRecordComponents/leaf.dart';
import 'package:dio/dio.dart';

import '../url.dart';

// import 'package:qrscan/qrscan.dart' as scanner;

class QRWidget extends StatefulWidget {
  QRWidget({super.key});

  @override
  State<QRWidget> createState() => _QRWidgetState();
}

class _QRWidgetState extends State<QRWidget> {
  String scanresult = "none"; //varaible for scan result text
  bool isScaned = false;
  List<String> CropsList = [];
  bool isListLoaded = false;
  @override
  void initState() {
    getCrops();
    scanresult = "none"; //innical value of scan result is "none"
    super.initState();
  }

  getCrops() async {
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
        CropsList.add(i["crop_name"]);
      }

      isListLoaded = true;
      print(CropsList);
    });

    // return res;
  }

  // final List<String> items = [
  //   'Crop1',
  //   'Crop2',
  //   'Crop3',
  //   'Crop4',
  //   'Crop5',
  //   'Crop6',
  //   'Crop7',
  //   'Crop8',
  // ];
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan QR",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 56, 193, 113),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container(child: Category()),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Crop',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: this
                          .CropsList
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });

                        print(selectedValue);
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for an item...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.value.toString().contains(searchValue));
                        },
                      ),
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => AddLeaf()),
                    // );
                    scanresult = await FlutterBarcodeScanner.scanBarcode(
                        '#ff6666', "Cancel", false, ScanMode.QR);
                    setState(() {
                      scanresult = scanresult;
                      if (scanresult == "-1") {
                        scanresult = "none";
                        isScaned = true;
                      } else {
                        isScaned = true;
                      }
                    });
                  },
                  child: Text(
                    'Scan QR',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 56, 193, 113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    child: isScaned ? Text("QR:$scanresult") : SizedBox()),
                // {scanresult?"none":Text("QR:$scanresult")};
                SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: true
                      ? ElevatedButton(
                          onPressed: () {
                            if (selectedValue == null) {
                              Fluttertoast.showToast(
                                  msg: "Kindly Select Crop ❌",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              // } else if (isScaned == false) {
                              //   Fluttertoast.showToast(
                              //       msg: "Kindly Scan QR ❌",
                              //       toastLength: Toast.LENGTH_SHORT,
                              //       gravity: ToastGravity.CENTER,
                              //       backgroundColor: Colors.black,
                              //       textColor: Colors.white,
                              //       fontSize: 16.0);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddLeaf(
                                        qr: scanresult,
                                        crop: selectedValue ?? "null")),
                              );
                            }
                          },
                          child: Text(
                            'Continue with $selectedValue',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 56, 193, 113),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
