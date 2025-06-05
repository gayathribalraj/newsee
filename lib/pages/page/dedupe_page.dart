import 'package:flutter/material.dart';
import 'package:newsee/pages/page/cif_search.dart';
import 'package:newsee/pages/page/dedup_search.dart';

class DedupeView extends StatelessWidget {
  final String title;

  DedupeView(String s, {required this.title, super.key});

  void _openModalSheet(BuildContext context, bool isNewCustomer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (BuildContext context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: isNewCustomer ? 0.9 : 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder:
                (_, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    border: Border.all(
                      width: 3,
                      color: Color.fromARGB(255, 3, 9, 110),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 3, 9, 110),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: isNewCustomer ? DedupeSearch() : CifSearchPage(),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool? selectedValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dedupe Details"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StatefulBuilder(
          builder:
              (context, setState) => Column(
                children: [
                  ListTile(
                    title: const Text("New Customer"),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() => selectedValue = value);
                        _openModalSheet(context, true);
                      },
                    ),
                    onTap: () {
                      setState(() => selectedValue = true);
                      _openModalSheet(context, true);
                    },
                  ),
                  ListTile(
                    title: const Text("Existing Customer"),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() => selectedValue = value);
                        _openModalSheet(context, false);
                      },
                    ),
                    onTap: () {
                      setState(() => selectedValue = false);
                      _openModalSheet(context, false);
                    },
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
