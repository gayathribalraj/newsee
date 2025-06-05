import 'package:flutter/material.dart';
import 'package:newsee/widgets/progress_bar.dart';
import 'package:newsee/widgets/skeleton.dart';

class DownloadProgressWidget extends StatelessWidget {
  const DownloadProgressWidget({
    super.key,
    required this.scrwidth,
    required this.scrheight,
    required this.downloadProgress,
  });

  final double scrwidth;
  final double scrheight;
  final double downloadProgress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scrwidth,
      height: scrheight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //use the reusable widget ProgressBar
              ProgressBarExample(progressValue: downloadProgress),
              const SizedBox(width: 30),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //use the reusable widget SkeletonLoader
                  SkeletonLoader(
                    height: 20,
                    // child: Container(),
                  ),
                  SizedBox(height: 10),
                  SkeletonLoader(
                    height: 15,
                    width: 80,
                    // child: Container(),
                  ),
                  SizedBox(height: 10),
                  SkeletonLoader(
                    height: 15,
                    width: 100,
                    // child: Container(),
                  ),
                  SizedBox(height: 10),

                  SkeletonLoader(
                    height: 15,
                    // child: Container(),
                  ),
                  SizedBox(height: 10),

                  SkeletonLoader(
                    height: 10,
                    width: 110,
                    // child: Container(),
                  ),
                  const SizedBox(height: 15),
                  // Text the Download Master
                  downloadProgress == 1
                      ? const Text(
                        'Master Download Success',
                        style: TextStyle(
                          color: Color.fromRGBO(214, 24, 24, 1),
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      )
                      : const Text(
                        'Downloading Master...',
                        style: TextStyle(
                          color: Color.fromRGBO(214, 24, 24, 1),
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                ],
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
