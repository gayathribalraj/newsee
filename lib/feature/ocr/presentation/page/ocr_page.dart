/* 
@author       : karthick.d  04/07/2025
@desc         : widget for processing text and extract desired ID number from 
                kyc by doing OCR technique
@param        : build method return CameraSurface which process the stream of 
                images and send a extracted text as callback
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';

class OCRScannerPage extends StatefulWidget {
  final Function(String) onTextDetected;

  const OCRScannerPage({required this.onTextDetected, super.key});

  @override
  _OCRScannerPageState createState() => _OCRScannerPageState();
}

class _OCRScannerPageState extends State<OCRScannerPage> {
  CameraController? _controller;
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer(
    script: TextRecognitionScript.latin,
  );
  bool _isProcessing = false;
  int _frameCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Check camera permission
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required for OCR'),
          ),
        );
        Navigator.pop(context);
        return;
      }
    }

    // Get available cameras
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No cameras available')));
      Navigator.pop(context);
      return;
    }

    // Initialize camera with NV21 format for better compatibility
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // nv21 format is must , because
      // google ml kit plugin have strict validation for this value for android
      // for ios it's must be bgra8888
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
      // Start processing frames
      _controller!.startImageStream(_processCameraImage);
    } catch (e) {
      print('Error initializing camera: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error initializing camera: $e')));
      Navigator.pop(context);
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    print('total frames processed....$_frameCounter');
    if (_isProcessing || !mounted) return;

    // Process every 5th frame to reduce performance overhead
    if (_frameCounter++ % 5 != 0) {
      return;
    }
    if (_frameCounter > 99) {
      await _controller?.stopImageStream();
      Navigator.pop(context);

      widget.onTextDetected('OCR Process failed , Scan a valid Document');
    }

    _isProcessing = true;

    try {
      // Convert CameraImage to InputImage
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) {
        print('Failed to convert CameraImage to InputImage');
        _isProcessing = false;
        return;
      }

      // Process image with TextRecognizer
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      String extractedText = recognizedText.text;

      if (extractedText.isNotEmpty && extractedText != null) {
        // Extract KYC ID
        String kycId = _extractKycId(extractedText)!;
        print('Extracted text: $extractedText');
        print('KYC ID: $kycId');

        // Stop stream and return result if KYC ID is found
        if (kycId.isNotEmpty) {
          await _controller?.stopImageStream();
          Navigator.pop(context);

          widget.onTextDetected(kycId);
          // if (mounted) {}
        }
      } else {
        print('No text detected in frame');
      }
    } catch (e) {
      print('Error processing image: $e');
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('Error processing image: $e')));
    } finally {
      _isProcessing = false;
    }
  }

  // Convert CameraImage to InputImage with full YUV420/NV21 data
  InputImage? _convertCameraImage(CameraImage image) {
    try {
      if (image.planes.isEmpty) {
        print('Error: CameraImage has no planes');
        return null;
      }

      // Validate dimensions
      final width = image.width;
      final height = image.height;
      if (width <= 0 || height <= 0) {
        print('Error: Invalid image dimensions ($width x $height)');
        return null;
      }

      // Validate bytesPerRow
      final bytesPerRow = image.planes[0].bytesPerRow;
      if (bytesPerRow <= 0) {
        print('Error: Invalid bytesPerRow ($bytesPerRow)');
        return null;
      }

      // Combine YUV420/NV21 planes
      final bytes = <int>[];
      for (var plane in image.planes) {
        if (plane.bytes.isEmpty) {
          print('Error: Empty plane data');
          return null;
        }
        bytes.addAll(plane.bytes);
      }

      print(
        'Converting image: ${width}x${height}, bytesPerRow: $bytesPerRow, planes: ${image.planes.length}, total bytes: ${bytes.length}',
      );

      // Get rotation from camera sensor orientation
      final rotation = _getInputImageRotation(
        _controller!.description.sensorOrientation,
      );

      return InputImage.fromBytes(
        bytes: Uint8List.fromList(bytes),
        metadata: InputImageMetadata(
          size: Size(width.toDouble(), height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: bytesPerRow,
        ),
      );
    } catch (e) {
      print('Error converting image: $e');
      return null;
    }
  }

  // Get correct rotation based on camera sensor orientation
  InputImageRotation _getInputImageRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  // Extract KYC ID from text using a regex
  String? _extractKycId(String text) {
    /// Example: 10-12 digit number or alphanumeric KYC ID
    ///
    /// RegExp kycPattern = RegExp(r'\b(?:\d{10,12}|[A-Z]{3}\d{9})\b');
    /// Aadhar card have some words in common
    /// like Government , Government of India , Male , Female , DOB string at the front side
    /// give weightage like AccuracyLevel = Very High , High , Moderate , Low , Very Low

    final tokens_aadhaar_country = [
      'Government',
      'Government of India',
      'Male',
      'Female',
      'DOB',
      'India',
    ];

    // test if the text has matches all the
    var AccuracyLevel = 0;
    for (final token in tokens_aadhaar_country) {
      if (text.toLowerCase().contains(token.toLowerCase())) {
        AccuracyLevel++;
      }
    }

    final accuracy = AccuracyLevel / tokens_aadhaar_country.length * 100;
    print('AccuracyLevel $accuracy');

    /// calculating accuracy
    /// AccuracyLevel/tokens_aadhaar_country.length * 100;
    ///

    RegExp kycPattern = RegExp(r'\b\d{4}[\s]\d{4}[\s]\d{4}\b');
    final match = kycPattern.firstMatch(text);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('OCR Scanner')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Center(
            child: Container(
              width: 300,
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Point camera at document',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  backgroundColor: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _controller?.stopImageStream();
          Navigator.pop(context);
        },
        child: const Icon(Icons.stop),
      ),
    );
  }

  @override
  void dispose() {
    try {
      _stopLiveFeed();
      _textRecognizer.close();
    } catch (e) {
      print('camera exception');
    } finally {
      super.dispose();
    }
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
