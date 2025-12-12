/*
  @author   : Gayathri
  @created  : 08/11/2025
  @desc     : Reusable class for handling style properties like width,
   height, padding, border radius, text style, background color, etc.
*/

import 'package:flutter/material.dart';

class StyleProps {
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final InputDecoration? inputDecoration;
  final CrossAxisAlignment? crossAxisAlignment;

  const StyleProps({
    this.borderRadius = 8,
    this.textStyle,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.inputDecoration,
    this.crossAxisAlignment,
  });
} 
