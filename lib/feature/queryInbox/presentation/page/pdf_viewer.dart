import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final File file;
  const PdfViewerScreen(this.file, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Document")),
      body: PDFView(
        filePath: file.path,
        enableSwipe: true,
        swipeHorizontal: false,
      ),
    );
  }
}
