import 'package:flutter/material.dart';

Future<void> openBottomSheet(
  BuildContext context,
  double initialChildSize,
  double minChildSize,
  double maxChildSize,
  Widget Function(BuildContext context, ScrollController ctrl) renderWidget,
) async {
  try {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder:
                (context, scrollController) =>
                    renderWidget(context, scrollController),
          ),
    );
  } catch (e) {
    print("Error opening bottom sheet: $e");
  }
}
