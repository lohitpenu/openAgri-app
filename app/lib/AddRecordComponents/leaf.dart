import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pest_app/AddRecordComponents/trap.dart';

class AddLeaf extends StatefulWidget {
  AddLeaf({super.key, required String this.qr, required String this.crop});
  String qr;
  String crop;
  @override
  State<AddLeaf> createState() => _AddLeafState();
}

class _AddLeafState extends State<AddLeaf> {
  late File imgPath;
  bool isLoaded = false;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Leaf Sample",
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
                    'Select Leaf Image',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 56, 193, 113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddTrap(
                                    qr: widget.qr,
                                    leaf: imgPath,
                                    crop: widget.crop)),
                          );
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 56, 193, 113),
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
