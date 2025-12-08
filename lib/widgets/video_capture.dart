import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:newsee/widgets/video_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoCapture extends StatefulWidget {
  const VideoCapture({super.key});

  @override
  State<VideoCapture> createState() => _VideoCaptureState();
}

class _VideoCaptureState extends State<VideoCapture> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool isRecording = false;

  int recordingSeconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  // Load camera
  Future<void> loadCamera() async {
    cameras = await availableCameras();

    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: true,
    );

    await controller!.initialize();
    setState(() {});
  }

  // Start recording
  Future<void> startRecording() async {
  if (!controller!.value.isInitialized) return;

  final dir = await getTemporaryDirectory();
  final filePath =
      '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

  await controller!.startVideoRecording();

  setState(() {
    isRecording = true;
    recordingSeconds = 0;
  });

  // Start live timer and automatic stop at 60 seconds
  timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    setState(() {
      recordingSeconds++;
    });

    // Stop automatically after 60 seconds
    if (recordingSeconds >= 3) {
      timer.cancel();
      await stopRecording(filePath);
    }
  });
}


  // Stop recording
  Future<void> stopRecording(String filePath) async {
    if (!controller!.value.isRecordingVideo) return;

    timer?.cancel();

    final file = await controller!.stopVideoRecording();
    final savedFile = File(file.path);

    // Move to final location
    await savedFile.copy(filePath);

    setState(() {
      isRecording = false;
      recordingSeconds = 0;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_video", filePath);

    debugPrint("Saved video: $filePath");

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPreview(videoPath: filePath)),
      );
    });
  }

  // Format seconds to HH:MM:SS
  String formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Video Capture")),
      body: Stack(
        children: [
          // Camera preview
          CameraPreview(controller!),

          // Live recording timer HH:MM:SS
          if (isRecording)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formatTime(recordingSeconds),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Capture / Stop button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed:
                    isRecording
                        ? () async {
                          final dir = await getTemporaryDirectory();
                          final filePath =
                              '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
                          await stopRecording(filePath);
                        }
                        : startRecording,
                child: Text(isRecording ? "Stop Recording" : "Capture Video"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
