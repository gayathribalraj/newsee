import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_report_table_model.dart';
import 'package:newsee/feature/cic_check/domain/repository/cibilreports_crud_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

/*
  @author     : Lathamani 30/11/2025
  @desc       : This page displays the HTML report in a WebView.
                It converts the base64 HTML data to a file and saves the file path in the table for future display
*/

class CibilHtmlViewer extends StatefulWidget {
  final String? htmlFileBase64;
  final String? localFilePath;
  final String? propNo;
  final String? applicantType;
  final String? reportType;
  const CibilHtmlViewer({
    super.key,
    this.htmlFileBase64,
    this.localFilePath,
    this.propNo,
    this.applicantType,
    this.reportType,
  });

  @override
  State<CibilHtmlViewer> createState() => CibilHtmlViewerState();
}

class CibilHtmlViewerState extends State<CibilHtmlViewer> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    loadHtml();
  }

  Future<void> loadHtml() async {
    try {
      String htmlContent;

      if (widget.localFilePath != null &&
          await File(widget.localFilePath!).exists()) {
        // load from saved local file
        htmlContent = await File(widget.localFilePath!).readAsString();
      } else if (widget.htmlFileBase64 != null &&
          widget.htmlFileBase64!.isNotEmpty) {
        htmlContent = utf8.decode(base64.decode(widget.htmlFileBase64!));
      } else {
        throw Exception('No html data or file path provided.');
      }
      // load into WebView
      await controller.loadHtmlString(htmlContent);
    } catch (e) {
      print('error loading html: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load CIBIL report')));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CIBIL Report'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
