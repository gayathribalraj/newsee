/*
author: Gayathri B
date: 01/07/2025
description: Video preview screen to preview recorded video before uploading
*/

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/feature/documentupload/data/datasource/document_datasource.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPreview extends StatefulWidget {
  String videoPath;
  final String finalDataValue;
  final String capturedTime;
  final String capturedDate;
  final String videoFile;

  VideoPreview({
    super.key,
    required this.videoPath,

    required this.finalDataValue,
    required this.capturedDate,
    required this.capturedTime,
    required this.videoFile,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? videoController;
  bool _disposed = false;
  bool isUploading = false;
  bool isDissabled = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  // initialize video player
  Future<void> initializeVideo() async {
    videoController = VideoPlayerController.file(File(widget.videoPath));

    await videoController!.initialize();

    if (!mounted || _disposed) return;

    setState(() {});
    videoController!.pause();
  }

  @override
  void dispose() {
    _disposed = true;
    videoController?.dispose();

    super.dispose();
  }

  // upload video to server
  Future<void> uploadVideo() async {
    if (isUploading) return;
    setState(() {
      isUploading = true;
    });

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Uploading video..."),
          duration: Duration(seconds: 2),
        ),
      );
      // create FormData for video upload
      final request = FormData.fromMap({
        // 'file': await MultipartFile.fromFile(widget.videoPath),
        'file': await MultipartFile.fromFile(widget.videoFile),
        'proposalNumber': '143560000001482',
        'userid': 'IOB3',
        'token':
            'U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3',
      });
      // call uploadVideo method from DocumentDataSource
      final documentDataSource = DocumentDataSource(dio: ApiClient().getDio());
      // get response
      final response = await documentDataSource.uploadVideo(request);
      if (!mounted) return;
      // response handling if success or failure
      if (response.data['Success'] == true) {
        showDialog(
          context: context,
          builder:
              (_) => SysmoAlert.success(
                message: "Video uploaded successfully.",
                onButtonPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
        );
      } else {
        showDialog(
          context: context,
          builder:
              (_) => SysmoAlert.failure(
                message: "Video uploaded Failed.",
                onButtonPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
        );
      }
    } catch (e) {
      debugPrint("Upload Error: $e");
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (_) => SysmoAlert.failure(
              message: "Video Upload Failed: $e",
              onButtonPressed: () {
                Navigator.pop(context);
              },
            ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Preview")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          // value listenable builder for video player
          child: ValueListenableBuilder(
            valueListenable: videoController!,
            builder: (context, value, child) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Center(
                        child:
                            (value.isInitialized)
                                ? AspectRatio(
                                  aspectRatio:
                                      videoController!.value.aspectRatio,
                                  child: VideoPlayer(videoController!),
                                )
                                : const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                      ),

                      const SizedBox(height: 20),
                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              if (videoController == null) return;

                              if (value.isPlaying) {
                                videoController!.pause();
                              } else {
                                videoController!.play();
                              }

                              if (mounted && !_disposed) setState(() {});
                            },
                            icon: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            label: Text(value.isPlaying ? "Pause" : "Play"),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              isUploading ? null : uploadVideo();
                            },
                            icon:
                                isUploading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(Icons.upload),
                            label: Text(
                              isDissabled
                                  ? "uploaded"
                                  : isUploading
                                  ? "Uploading.."
                                  : "upload",
                            ),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                widget.videoPath = "";
                              });
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.camera),
                            label: const Text("Record Again"),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // location of the latitude longtitude
                  Positioned(
                    bottom: 30,
                    right: 0,
                    child: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Text(
                                "Address: ${widget.finalDataValue}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              widget.capturedDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.capturedTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


/*

Widget build(BuildContext context){
  return ValueListenableBuilder<VideoPlayerValue>(context,value){
    listenable : _value,
    builder : (context){

      return Row(
      children : [
      IconButton( _value.isPlaying ? Icon.play : Icon.pause)
      ]
      )
    }
  }
}

*/