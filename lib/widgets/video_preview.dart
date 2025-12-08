import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPreview extends StatefulWidget {
  final String videoPath;

  const VideoPreview({super.key, required this.videoPath});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        videoController!.pause();
      });
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Preview")),
      body: Column(
        children: [
          Center(
            child:
                videoController != null && videoController!.value.isInitialized
                    ? AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                    )
                    : const CircularProgressIndicator(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    videoController!.value.isPlaying
                        ? videoController!.pause()
                        : videoController!.play();
                  });
                },
                label: Text('Play Video'),
                icon: Icon(
                  videoController != null && videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                label: Text('Upload Video'),
                icon: Icon(Icons.upload),
              ),
              TextButton.icon(
                onPressed: () {},
                label: Text('recaptcha Video'),
                icon: Icon(Icons.camera),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
