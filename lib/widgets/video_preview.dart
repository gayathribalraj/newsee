import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPreview extends StatefulWidget {
  String videoPath;
  final String finalDataValue;
  final String capturedTime;
  final String capturedDate;

  VideoPreview({
    super.key,
    required this.videoPath,

    required this.finalDataValue,
    required this.capturedDate,
    required this.capturedTime,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? videoController;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Preview")),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
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
                                  aspectRatio: videoController!.value.aspectRatio,
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
                             value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            label: Text(
                             value.isPlaying
                                  ? "Pause"
                                  : "Play",
                            ),
                          ),
              
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Uploading...")),
                              );
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text("Upload"),
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
                    bottom: 85,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              "address: ${widget.finalDataValue}",
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
                ],
              );
            }
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