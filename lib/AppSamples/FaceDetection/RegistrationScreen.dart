import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:newsee/AppSamples/FaceDetection/RecognitionScreen.dart';

import '../../ML/Recognition.dart';
import '../../ML/Recognizer.dart';
import '../../Utils/ocr_utils.dart';


class RegistrationScreen extends StatefulWidget {
  final Function(Map<String,String> recognitons)? onRegistrationSuccess;

  const RegistrationScreen({Key? key,this.onRegistrationSuccess}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationScreen> {
  //TODO declare variables
  late ImagePicker imagePicker;
  File? _image;

  //TODO declare detector
  late FaceDetector faceDetector;


  //TODO declare face recognizer
  late Recognizer recognizer;

  Map<String, String> ocrresult = {};
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer(
    script: TextRecognitionScript.latin,
  );


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

  doFaceDetection() async {
    //TODO remove rotation of camera images
    _image = await removeRotation(_image!);

    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);

    //TODO passing input to face detector and getting detected faces
    InputImage inputImage = InputImage.fromFile(_image!);
    // InputImage.fromBytes(bytes: bytes, metadata: metadata);
    final RecognizedText recognizedText = await _textRecognizer.processImage(
      inputImage,
    );
    String extractedText = recognizedText.text;
    print('extractedText : $extractedText');
    var _ocrresult = extractDLInfo(extractedText);

    faces = await faceDetector.processImage(inputImage);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left<0?0:faceRect.left;
      num top = faceRect.top<0?0:faceRect.top;
      num right = faceRect.right>image.width?image.width-1:faceRect.right;
      num bottom = faceRect.bottom>image.height?image.height-1:faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      final bytes = _image!.readAsBytesSync();//await File(cropedFace!.path).readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes!);
      img.Image croppedFace = img.copyCrop(faceImg!,x:left.toInt(),y:top.toInt(),width:width.toInt(),height:height.toInt());
      final recognition = recognizer.recognize(croppedFace, faceRect);

      showFaceRegistrationDialogue(Uint8List.fromList(img.encodeBmp(croppedFace)), recognition,_ocrresult);

    }

    drawRectangleAroundFaces();
    //TODO call the method to perform face recognition on detected faces
  }

  var image;

  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
    setState(() {
      image;
    });
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(
        await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //TODO perform Face Recognition

  //TODO Face Registration Dialogue
  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(Uint8List cropedFace, Recognition recognition , Map<String, String> ocrdata){
    textEditingController.value = TextEditingValue(text: ocrdata['name']!);
    print("ocrdata => $ocrdata ${ocrdata['name']} ${ocrdata['id']} ${ocrdata['name']}");
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration",textAlign: TextAlign.center),alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SizedBox(
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Image.memory(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration( fillColor: Colors.white, filled: true,hintText: "Enter Name")
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: TextEditingController(text: ocrdata['id']),
                    decoration: const InputDecoration( fillColor: Colors.white, filled: true,hintText: "Enter Name")
                ),
              ),
              const SizedBox(height: 10,),

              ElevatedButton(
                  onPressed: () {
                    recognizer.registerFaceInDB(textEditingController.text, recognition.embeddings);
                    ocrresult = ocrdata;
                    setState(() {

                    });
                    textEditingController.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                    widget.onRegistrationSuccess!(ocrresult);
                  },style: ElevatedButton.styleFrom(backgroundColor:  Colors.blue,minimumSize: const Size(200,40)),
                  child: const Text("Register"))
            ],
          ),
        ),contentPadding: EdgeInsets.zero,
      ),
    );
  }
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
          image != null
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
                width: image.width.toDouble(),
                height: image.width.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(
                      facesList: faces, imageFile: image),
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
          SizedBox(
            height: 20,
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const RecognitionScreen()));
          //   },
          //   style: ElevatedButton.styleFrom(
          //       minimumSize: Size(screenWidth - 30, 50)),
          //   child: const Text("Verify"),
          // ),

          Container(
            height: 50,
          ),

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
                          color: Colors.blue, size: screenWidth / 7),
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
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: InkWell(
                    onTap: () {

                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Icon(Icons.compare,
                          color: Colors.black, size: screenWidth / 7),
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
  List<Face> facesList;
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

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}