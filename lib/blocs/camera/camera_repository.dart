import 'dart:typed_data';

import 'package:camera/camera.dart';

class CameraCaptureResponse {
  final XFile xfile;
  final Uint8List imageData;

  CameraCaptureResponse({required this.xfile, required this.imageData});
}
