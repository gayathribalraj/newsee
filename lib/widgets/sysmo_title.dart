import 'package:flutter/material.dart';

class SysmoTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const SysmoTitle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color.fromARGB(135, 0, 15, 14), width: 2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
                Icon(icon,color:Colors.red, size: 30,),
                SizedBox(height:8),
                 Center(
                   child: Flexible(
                     child: Padding(
                       padding: const EdgeInsets.all(8),
                       child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          
                        ),
                                       
                                     ),
                     ),
                   ),
                 ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Align(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 19,),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
