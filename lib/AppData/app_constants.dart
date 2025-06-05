import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConstants {
  static final RegExp PATTERN_SPECIALCHAR = RegExp(
    r'[\*\%!$\^.,;:{}\(\)\-_+=\[\]]',
  );

  static final RegExp PATTER_ONLYALPHABET = RegExp(r'(\w+)');
}

class BioMetricResult {
  final String message;
  final bool status;

  BioMetricResult({required this.message, required this.status});
}

class FilePickingOptionList {
  final IconData icon;
  final String title;
  FilePickingOptionList({required this.icon, required this.title});
}
