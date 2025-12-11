import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_file_sourece_selector.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_files_viewer.dart';
import 'package:newsee/feature/videocapturing/video_capture.dart';

class DocumentList extends StatelessWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        if (state.documentsList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 50),
                Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  "No documents added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              children: [
                 ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.documentsList.length,
                itemBuilder: (context, index) {
                  final doc = state.documentsList[index];
                  return DocumentItem(doc: doc, index: index);
                },
              ),
              VideoItem()
              ],
             
            ),
          ),
        );
      },
    );
  }
}

class DocumentItem extends StatelessWidget {
  final DocumentModel doc;
  final int index;

  const DocumentItem({super.key, required this.doc, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool hasImages = doc.imgs.isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  '${doc.lpdDocDesc}${doc.lpdManCheck == 'M' ? " *" : ""}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed:
                    () =>
                        showFileSourceSelector(context, index, doc.lpdDocDesc),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () async {
                      if (doc.imgs.isNotEmpty) {
                        final outerContext = context;
                        showModalBottomSheet(
                          context: outerContext,
                          builder: (_) {
                            return BlocProvider.value(
                              value: outerContext.read<DocumentBloc>(),
                              child: ShowFilesViewer(docIndex: index),
                            );
                          },
                        );
                      }
                    },
                  ),
                  if (hasImages)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${doc.imgs.length}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[200]),
      ],
    );
  }
}

captureVideo(context) {
  try {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => VideoCapture(
              finalData: '', 
              capturedDate: '', 
              capturedTime: '', 
              videoFile: ''
            )
      ),
    );
  } catch(error) {
    print("cpatureVideo-error $error");
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem({super.key});

  @override
  Widget build(BuildContext context) {
    // final bool hasImages = doc.imgs.isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Capture Video',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.video_call_sharp, color: Colors.black),
                onPressed:
                    () =>
                        captureVideo(context),
              ),
              // Stack(
              //   clipBehavior: Clip.none,
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.remove_red_eye),
              //       onPressed: () async {
              //         captureVideo(context);
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[200]),
      ],
    );
  }
}
