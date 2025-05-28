import 'package:flutter/material.dart';
import 'maintain.dart';
import 'reachus.dart';
import 'more.dart';

mpin(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration:BoxDecoration(
          
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (i) {
                return Container(
                
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: i == 0
                      ? Center(
                          child: IconButton(onPressed: (){}, icon: Icon(Icons.fingerprint, size: 35,color: Color.fromARGB(255, 3, 9, 110),),),
                        )
                      : Center(
                        child: TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(counterText: '',
                             border: InputBorder.none, 
                            
                            ),
                          
                            
                            onChanged: (v) {
                              if (v.isNotEmpty && i + 1 < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                      ),
                );
              }),
            ),

            //  SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          maintenanceActionSheet(
                            context,
                            "Comming Soon....",
                            "We are Working to improve Your experence with our new mobile app.",
                            Icons.person,
                            "okay",
                          );
                        },
                        icon: Icon(
                          Icons.medical_information,
                          color: const Color.fromARGB(246, 4, 13, 95),
                        ),
                        label: Text(
                          'Maintenance',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          reachUsActionSheet(
                            context,
                            "Reach Us...",
                            "Whatsapp",
                            "ContactUs",
                            "BranchLocator",
                            Icons.phone,
                            Icons.location_pin,
                          );
                        },
                        icon: Icon(
                          Icons.movie_creation_rounded,
                          color: const Color.fromARGB(246, 4, 13, 95),
                        ),
                        label: Text(
                          'Reach Us',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          moreActionSheet(context, 'Okay');
                        },
                        icon: Icon(
                          Icons.more,
                          color: const Color.fromARGB(246, 4, 13, 95),
                        ),
                        label: Text(
                          'More',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            
          ],

        
        ),
      );
    },
  );
}
