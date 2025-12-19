import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../../ML/LivenessDetector.dart';
import '../../ML/Recognition.dart';
import '../../ML/Recognizer.dart';


class RecognitionScreen extends StatefulWidget {
  final String name;
  final Function(Uint8List imageArray) onVerifed;
  const RecognitionScreen({super.key , required this.name , required this.onVerifed});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  //TODO declare variables
  late ImagePicker imagePicker;
  File? _image;
  img.Image? croppedImage;
  //TODO declare detector
  late FaceDetector faceDetector;


  //TODO declare face recognizer
  late Recognizer recognizer;
  LivenessDetector livenessDetector = LivenessDetector();
  bool isLive = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();

    //TODO initialize face detector
    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);


    //TODO initialize face recognizer
    recognizer = Recognizer();

  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  //TODO face detection code here

  List<Face> faces = [];
  List<Recognition> recognitions = [];
  var decodedImage;

  doFaceDetection() async {
    recognitions.clear();

    //TODO remove rotation of camera images
    _image = await removeRotation(_image!);

    decodedImage = await _image?.readAsBytes();
    decodedImage = await decodeImageFromList(decodedImage);

    //TODO passing input to face detector and getting detected faces
    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left<0?0:faceRect.left;
      num top = faceRect.top<0?0:faceRect.top;
      num right = faceRect.right>decodedImage.width?decodedImage.width-1:faceRect.right;
      num bottom = faceRect.bottom>decodedImage.height?decodedImage.height-1:faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      final bytes = _image!.readAsBytesSync();//await File(cropedFace!.path).readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes);
      img.Image croppedFace = img.copyCrop(faceImg!,x:left.toInt(),y:top.toInt(),width:width.toInt(),height:height.toInt());
      croppedImage = croppedFace;
      final recognition = recognizer.recognize(croppedFace, faceRect);
      img.Image face224 = img.copyResize(
        croppedImage!,
        width: 224,
        height: 224,
      );
       isLive = await livenessDetector.isLive(face224);
      print('isLive => $isLive');
      if(!isLive){
        showDialog(context: context, builder: (ctx)=> AlertDialog(
          title: Text('Spoof Detected'),
        ));
        setState(() {
          isLive;
        });
        return;
      }else {
        recognitions.add(recognition);
        setState(() {
          isLive;
          croppedImage;
          decodedImage;
        });
      }
    }

    drawRectangleAroundFaces();
    //TODO call the method to perform face recognition on detected faces
  }


  drawRectangleAroundFaces() async {
    decodedImage = await _image?.readAsBytes();
    decodedImage = await decodeImageFromList(decodedImage);
    print("${decodedImage.width}   ${decodedImage.height}");
    setState(() {
      recognitions;
      decodedImage;
      faces;
    });
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(
        await File(inputImage.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //TODO perform Face Recognition

  //TODO Face Registration Dialogue

  //TODO draw rectangles
  // var image;
  // drawRectangleAroundFaces() async {
  //   image = await _image?.readAsBytes();
  //   image = await decodeImageFromList(image);
  //   print("${image.width}   ${image.height}");
  //   setState(() {
  //     image;
  //     faces;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          decodedImage != null
              ?
          // Container(
          //         margin: const EdgeInsets.only(top: 100),
          //         width: screenWidth - 50,
          //         height: screenWidth - 50,
          //         child: Image.file(_image!),
          //       )
          Container(
            margin: const EdgeInsets.only(
                top: 60, left: 30, right: 30, bottom: 0),
            child: FittedBox(
              child: SizedBox(
                width: decodedImage.width.toDouble()+500,
                height: decodedImage.width.toDouble()-200,
                child: CustomPaint(
                  painter: FacePainter(
                      facesList: recognitions, imageFile: decodedImage!),
                ),

              ),
            ),
          )
              : Container(
            margin: const EdgeInsets.only(top: 100),
            child: Image.asset(
              "assets/images/logo.png",
              width: screenWidth - 100,
              height: screenWidth - 100,
            ),
          ),


          Container(
            height: 50,
          ),
          recognitions.isNotEmpty && isLive ?

          Card(

            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 60,
                      child: Icon(Icons.verified,
                          color: Colors.green, size: screenWidth / 7),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(recognitions[0].name,style:TextStyle(
                            letterSpacing: 1.5,
                            fontSize: 14
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child:  Text('Liveliness Verified Successfully...!!!' , style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 14
                          ),),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (croppedImage != null) {
                                final imageData = Uint8List.fromList(img.encodePng(croppedImage!));
                                widget.onVerifed(imageData); // now safe to use !
                                Navigator.pop(context);
                              } else {
                                // Optional: show a message if nothing to verify
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("No face detected yet!")),
                                );
                              }
                            },
                            child: Text('ok'))
                      ],
                    )


                  ],
                )
          ): SizedBox(width: 50,),
          //TODO section which displays buttons for choosing and capturing images
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: InkWell(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Icon(Icons.image,
                          color: Colors.blue, size: screenWidth / 10),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Icon(Icons.camera,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
class FacePainter extends CustomPainter {
  List<Recognition> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Recognition rectangle in facesList) {
      canvas.drawRect(rectangle.location, p);

      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.green, fontSize: 80,letterSpacing: 6.0),
          text: "${rectangle.name}  ${rectangle.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(rectangle.location.left, rectangle.location.top));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}