
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../feature/facedetection/presentation/page/face_detection.dart';
import 'RecognitionScreen.dart';
import 'RegistrationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  Uint8List? cropedFace;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          cropedFace == null ?
          Container(
              margin: const EdgeInsets.only(top: 100),
              child: Image.asset(
                "assets/logo.jpg",
                width: screenWidth - 40,
                height: screenWidth - 40,
              )) : Image.memory(
            cropedFace!,
            width: 80,
            height: 80,
            fit: BoxFit.fill,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FaceDetectionPage(
                          onVerifed: (imageArray) {
                            cropedFace = imageArray;
                            print('croppedface => $cropedFace');
                            setState(() {});
                          },
                        ),
                        // (context)=>RegistrationScreen()
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth - 30, 50)),
                  child: const Text("Register"),
                ),
                Container(
                  height: 20,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}