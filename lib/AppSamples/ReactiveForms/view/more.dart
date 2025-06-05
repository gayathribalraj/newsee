import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsee/AppSamples/ReactiveForms/forms.dart';

/*

@author : Gayathri.b    14/05/25
@description : Displays a cupertino action sheet labled "more" with a grid layout of 
               loan categories and additional services and primary action button at the bottom of sheet 

 @props       : - BuildContext context : The context in which the Cupertino modal is displayed.
                - String action        : action button at the bottom of the sheet.


 */

//Define the function take context pharameters
void moreActionSheet(BuildContext context, String action) {
  //popup the action sheet
  showCupertinoModalPopup<void>(
    context: context,
    builder:
        (BuildContext context) => CupertinoActionSheet(
          //title the action sheet
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40, right: 20),
                child: Text(
                  'More',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              //First Row of Loan options
              SingleChildScrollView(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Retail Loan
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(130, 158, 158, 158),
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/Retail.svg',
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  'MLAP Loan',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Agree Loan
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(130, 158, 158, 158),
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/Agri_Loan.svg',
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  'Agree Loan',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //MSME Loan
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(130, 158, 158, 158),
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/MSME.svg',
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  'MSME Loan',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Second row of loan options
              SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //home Loan
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(130, 158, 158, 158),
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/Home_Loan.svg',
                                  height: 50,
                                  width: 50,
                                ),
                                Text(
                                  'Home Loan',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //vehicle Loan
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(130, 158, 158, 158),
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/Vehicle_Loan.svg',
                                  height: 50,
                                  width: 50,
                                ),
                                Text(
                                  'Vehicle Loan',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Gold Loan
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(130, 158, 158, 158),
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/Gold_Loan.svg',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Gold Loan',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              //Section for other Services
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Header of Other services
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 40,
                          right: 20,
                        ),
                        child: Text(
                          "OTHER SERVICES",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Manage e-Mandates row
                              Icon(Icons.currency_rupee_rounded),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  'Service One',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,

                              color: const Color.fromARGB(198, 7, 61, 105),
                              size: 20,
                              weight: 80,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_add_alt),
                              //Update employer Details
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  'Service Two',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,

                              color: const Color.fromARGB(198, 7, 61, 105),
                              size: 20,
                              weight: 80,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //main action button of the action buttom
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                //close the bottom sheet
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: const Color.fromARGB(255, 3, 9, 110),
                    child: Text(
                      action,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
  );
}
