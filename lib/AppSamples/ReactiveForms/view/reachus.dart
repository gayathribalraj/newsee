import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contactUs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*
@action : Gayathri.b    15/05/2025
@description : Display the cupertino action sheet labeled "Reach us" with each action button like 
              whatsapp , contactus and branch locator and also when the click whatsapp button go to the whatsapp chat 
              and click the contact button show  cupertino action sheet with  two options show the phone numbers  

@ props : -BuilderContext context : The context in witch the cupertino modal displayed.
          -title : title displayed at the topof the action sheet .
          -the First action sheet whatsapp
          -the Secons action sheet contactUs
          -the third action sheet location 
          -icondata show the Each action button


 */

//Define the function take mulitiple pharameter and also take context
void reachUsActionSheet(
  BuildContext context,
  String title,
  String heading1,
  String heading2,
  String heading3,
  IconData icon2,
  IconData icon3,
) {
  //popup the action sheet
  showCupertinoModalPopup<void>(
    context: context,
    builder:
        (BuildContext context) => CupertinoActionSheet(
          title: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          //List of action sheets...
          actions: [
            //List of  First Whatsapp
            CupertinoActionSheetAction(
              onPressed: () async {
                //  whasapp();
                final phoneNumber = "919940362579";
                final Uri url = Uri.parse('https://wa.me/sms:$phoneNumber');
                // final Uri _url = Uri.parse('https://flutter.dev');

                if (!await canLaunchUrl(url)) {
                  throw 'Could not launch $url';
                } else {
                  await launchUrl(url);
                }
                Navigator.pop(context);
              },

              //set icon svg for whatsapp
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/whatsapp.svg',
                    height: 40,
                    width: 40,
                  ),
                  // Icon(
                  //   icon1,
                  //   color: const Color.fromARGB(255, 32, 219, 35),
                  //   size: 30,
                  // ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      heading1,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),

            // List of Second contact
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                contact(
                  context,
                  "Contact US",
                  "1888762666",
                  "1903833773",
                  Icons.phone,
                );
              },
              child: Row(
                children: [
                  Icon(
                    icon2,
                    color: const Color.fromARGB(255, 231, 9, 9),
                    size: 35,
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      heading2,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            // //location
            // CupertinoActionSheetAction(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: Row(
            //     children: [
            //       Icon(
            //         icon3,
            //         color: const Color.fromARGB(255, 3, 9, 110),
            //         size: 35,
            //       ),
            //       SizedBox(width: 20),
            //       Padding(
            //         padding: const EdgeInsets.all(10),
            //         child: Text(
            //           heading3,
            //           style: TextStyle(color: Colors.black, fontSize: 20),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
  );
}
