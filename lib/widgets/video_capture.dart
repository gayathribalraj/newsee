import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/widgets/video_preview.dart';

class VideoCapture extends StatefulWidget {
  String capturedTime;
  String capturedDate;
  String finalData;

  VideoCapture({
    super.key,
    required this.finalData,
    required this.capturedDate,
    required this.capturedTime,
  });

  @override
  State<VideoCapture> createState() => _VideoCaptureState();
}

class _VideoCaptureState extends State<VideoCapture> {
  CameraController? controller;
  List<CameraDescription> cameras = [];

  bool isRecording = false;
  bool isProcessing = false;
  int recordingSeconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  Future<void> loadCamera() async {
    try {
      cameras = await availableCameras();
      controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("Camera Init Error: $e");
    }
  }

  Future<void> startRecording() async {
    if (isProcessing) return;
    if (controller == null || !controller!.value.isInitialized) return;

    isProcessing = true;

    try {
      await controller!.startVideoRecording();

      setState(() {
        isRecording = true;
        recordingSeconds = 0;
      });

      timer = Timer.periodic(const Duration(seconds: 1), (t) async {
        if (!mounted) return;

        setState(() => recordingSeconds++);

        if (recordingSeconds >= 30) {
          t.cancel();
          await stopRecording();
        }
      });
    } catch (e) {
      debugPrint("Start Recording Error: $e");
    } finally {
      isProcessing = false;
    }
  }

  Future<void> stopRecording() async {
    if (isProcessing) return;
    if (controller == null || !controller!.value.isRecordingVideo) return;

    isProcessing = true;

    try {
      timer?.cancel();

      XFile recordedFile = await controller!.stopVideoRecording();
      final recordedPath = recordedFile.path;

      final tempDir = await getTemporaryDirectory();
      final String newPath =
          "${tempDir.path}/recorded_${DateTime.now().millisecondsSinceEpoch}.mp4";

      final File tempVideo = await File(recordedPath).copy(newPath);
      debugPrint("TEMP VIDEO STORED PATH => $newPath");

      final String capturedDate =
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

      final String capturedTime =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";

      setState(() {
        isRecording = false;
        recordingSeconds = 0;
      });

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => VideoPreview(
                videoPath: tempVideo.path,
                finalDataValue: widget.finalData,
                capturedDate: capturedDate,
                capturedTime: capturedTime,
              ),
        ),
      );
    } catch (e) {
      debugPrint("Stop Recording Error: $e");
    } finally {
      isProcessing = false;
    }
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Video Capture")),
      body: Stack(
        children: [
          CameraPreview(controller!),

          if (isRecording)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
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

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed:
                    isProcessing
                        ? null
                        : isRecording
                        ? () async => await stopRecording()
                        : () async {
                          final location = await MediaService().getLocation(
                            context,
                          );

                          final placeMark = await MediaService()
                              .getLocationDetails(
                                location.position!.latitude,
                                location.position!.longitude,
                              );

                          final placeDetails = jsonEncode(placeMark[0]);
                          final placeData = jsonDecode(placeDetails);

                          final cleaned =
                              [
                                    placeData['name'],
                                    placeData['street'],
                                    placeData['subThoroughfare'],
                                    placeData['thoroughfare'],
                                    placeData['subLocality'],
                                    placeData['locality'],
                                    placeData['subAdministrativeArea'],
                                    placeData['administrativeArea'],
                                    placeData['postalCode'],
                                    placeData['country'],
                                    placeData['isoCountryCode'],
                                  ]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .toList();

                          final int splitIndex = cleaned.length - 4;

                          final finalData =
                              "${cleaned.take(splitIndex).join(',')}\n${cleaned.skip(splitIndex).join(', ')}";

                          widget.finalData = finalData;

                          await startRecording();
                        },
                child: Text(isRecording ? "Stop Recording" : "Capture Video"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
