/*
  @author   : Gayathri
  @created  : 08/11/2025
  @desc     : Reusable class for handling button properties like label, color, size, border radius, padding, disabled state, and onPressed callback.
*/

import 'package:flutter/material.dart';

class ButtonProps {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool disabled;

  const ButtonProps({
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 8.0,
    this.padding,
    this.disabled = false,
  });

}
