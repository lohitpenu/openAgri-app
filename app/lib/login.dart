import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pest_app/home.dart';
import 'package:dio/dio.dart';
import 'package:pest_app/register.dart';
import 'package:pest_app/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();

  loginUser(email, password) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      "email": email,
      "password": password,
    });
    print("FORM DATA IS XxXXXXXXXXXX");
    print(formData);
    final response = await dio.post(url + '/api/login/', data: formData);
    print(response);
    // print(response.data["desc"]);
    Fluttertoast.showToast(
        msg: response.data["desc"],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    if ((response.data["status"]) == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('username', email);
      print("Going to Home");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => route is Login,
      );
    }

    return (response.data["status"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 56, 193, 113),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  textAlign: TextAlign.center,
                  controller: email,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 56, 193, 113), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    fillColor: Color.fromARGB(255, 56, 193, 113),
                    filled: true,
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  controller: password,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 56, 193, 113), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    fillColor: Color.fromARGB(255, 56, 193, 113),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Future<dynamic> status = loginUser(
                          email.text.toString(), password.text.toString());
                      print(status.toString());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Home()),
                      // );
                      // Fluttertoast.showToast(
                      //     msg: "Uploaded Successfully ✅",
                      //     toastLength: Toast.LENGTH_LONG,
                      //     gravity: ToastGravity.CENTER,
                      //     backgroundColor: Colors.black,
                      //     textColor: Colors.white,
                      //     fontSize: 16.0);
                    },
                    child: Text(
                      'Login',
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
                SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Text("Not Registered? Register Here"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
