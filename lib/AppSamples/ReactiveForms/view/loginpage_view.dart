// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get_it/get_it.dart';
// import 'package:newsee/AppData/app_constants.dart';
// import 'package:newsee/AppData/globalconfig.dart';
// import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:newsee/Utils/local_biometric.dart';
// import 'package:newsee/Utils/shared_preference_utils.dart';
// import 'package:newsee/Utils/utils.dart';
// import 'package:newsee/core/api/api_client.dart';
// import 'package:newsee/feature/globalconfig/bloc/global_config_bloc.dart';
// import 'package:newsee/feature/pdf_viewer/presentation/pages/pdf_viewer_page.dart';
// import 'package:newsee/widgets/bottom_sheet.dart';
// import 'package:newsee/widgets/options_sheet.dart';
// import 'package:newsee/widgets/sysmo_alert.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../../feature/forgetmpin/presentation/page/forgetpassword.dart';
// import 'maintain.dart';
// import 'reachus.dart';
// import 'more.dart';
// import 'login_mpin.dart';

// /*
// author : Gayathri B
// description : A stateless widget that serves as the main login screen for the app. It offers
//               users multiple ways to authenticate and access frequently used features:
//             - Login using fingerprint (biometric authentication)
//               - Login with account  username and password
//               - Login using mPIN
//               - Option to reset mPIN via action sheet
//               - Access to additional options like Maintenance, Reach Us, and More

//  */

// class LoginpageView extends StatelessWidget {
//   Future fingerPrintScanner(context) async {
//     final result =
//         await GetIt.instance
//             .get<BioMetricLogin>()
//             .biometricAuthenticationWithKey();
//     final user = await loadUser();

//     print(
//       ' biometric auth response => ${result.message} :: ${result.status} user :: ${user?.LPuserID}',
//     );
//   }

//   /*
// @author     : karthick.d  07/08/2025
// @desc       : when panning gesture detected with 2 finger pointers
//               opening bottomsheet , when clicking enable offline mode
//               will set the
//  */
//   Widget renderSettingWidget(BuildContext context, GlobalConfigState state) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           const SizedBox(height: 12),
//           OptionsSheet(
//             icon:
//                 state.globalconfig.operationNetwork == OperationNetwork.online
//                     ? Icons.signal_wifi_connected_no_internet_4
//                     : Icons.network_wifi,
//             title:
//                 state.globalconfig.operationNetwork == OperationNetwork.online
//                     ? "Enable Offline Mode"
//                     : "Enable Online Mode",
//             subtitle: "Hassle-free Lead Onboarding",
//             onTap: () {
//               // set operation network value based on which offline feature enabled
//               if (state.globalconfig.operationNetwork ==
//                   OperationNetwork.online) {
//                 context.read<GlobalConfigBloc>().add(
//                   NetworkChangedEvent(
//                     Globalconfig.fromValue(network: OperationNetwork.offline),
//                   ),
//                 );
//               } else {
//                 context.read<GlobalConfigBloc>().add(
//                   NetworkChangedEvent(
//                     Globalconfig.fromValue(network: OperationNetwork.online),
//                   ),
//                 );
//               }

//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final screenWidth = size.width;
//     final screenHeight = size.height;
//     //Header section of the landing page
//     return Scaffold(
//       body: BlocConsumer<GlobalConfigBloc, GlobalConfigState>(
//         listener: (context, state) {
//           print('on bloc listener => ${state.globalconfig.operationNetwork}');
//         },
//         builder:
//             (context, state) => GestureDetector(
//               onScaleEnd: (details) {
//                 print(
//                   'SCALE END DETAILS => velocity : ${details.velocity} scalevelocity ${details.scaleVelocity} pointerCount : ${details.pointerCount}',
//                 );
//                 if (details.pointerCount >= 2) {
//                   //openBottomSheet(context, 0.3, 0.2, 0.9, renderSettingWidget);
//                   showBottomSheet(
//                     backgroundColor: Colors.amber,
//                     constraints: BoxConstraints(maxHeight: screenHeight * 0.2),
//                     context: context,
//                     builder: (modalcontext) {
//                       return renderSettingWidget(context, state);
//                     },
//                   );
//                 }
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: screenWidth,
//                     height: screenHeight * 0.31,
//                     child: SvgPicture.asset(
//                       'assets/app_background_2.svg',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.01),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(5),
//                             child: Container(
//                               width: double.infinity,

//                               // decoration: BoxDecoration(
//                               //   borderRadius: BorderRadius.only(
//                               //     topLeft: Radius.circular(0),
//                               //     topRight: Radius.circular(0),
//                               //   ),
//                               //   gradient: LinearGradient(
//                               //     colors: [
//                               //       const Color(0xC5F1ECF1),
//                               //       Colors.white,
//                               //     ],
//                               //     begin: Alignment.topCenter,
//                               //     end: Alignment.bottomCenter,
//                               //   ),
//                               // ),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   SizedBox(height: screenHeight * 0.03),

//                                   //Login using fingerprint (biometric authentication)
//                                   IconButton(
//                                     onPressed: () {
//                                       fingerPrintScanner(context);
//                                     },
//                                     icon: Icon(Icons.fingerprint),
//                                     iconSize: screenWidth * 0.18,
//                                     color: const Color.fromARGB(255, 3, 9, 110),
//                                   ),

//                                   Text(
//                                     "Login with Fingerprint",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.045,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.03),
//                                   // users multiple ways to authenticate and access frequently used features
//                                   Text(
//                                     "Frequently used features & special offers at your fingertips",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.035,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.06),

//                                   // this function returns a widget that is a row with icon button
//                                   // served as quick links to access other apk files for other loans
//                                   //quickLink(screenHeight, screenWidth),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.04),

//                           // Login with account  username and password
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               vertical: screenHeight * 0.01,
//                               horizontal: screenWidth * 0.12,
//                             ),
//                             child: Center(
//                               child: ElevatedButton.icon(

//                                 onPressed: () {
//                                   loginActionSheet(
//                                     context,
//                                     state.globalconfig.operationNetwork,
//                                     createMPIN: false,
//                                   );
//                                   //  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginBlocProvide()),);
//                                 },
//                                 icon: Icon(Icons.login, color: Colors.white),
//                                 label: Text(
//                                   "Login with Account",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: screenWidth * 0.045,
//                                   ),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   minimumSize: Size(
//                                     double.infinity,
//                                     screenHeight * 0.06,
//                                   ),

//                                   backgroundColor: const Color.fromARGB(
//                                     246,
//                                     4,
//                                     13,
//                                     95,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Login using mPIN
//                               TextButton(
//                                 onPressed: () {
//                                   mpin(context, null);
//                                 },
//                                 child: Text(
//                                   "Or, login with mPIN",
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                   ),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   forgetActionSheet(
//                                     context,
//                                     "Reset mPIN",
//                                     "Do you want to reset your mPIN?",
//                                     Icons.lock_reset,
//                                     "Reset",
//                                     "Cancel",
//                                   );
//                                 },
//                                 child: Text(
//                                   "Forgot mPIN?",
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: screenHeight * 0.1),

//                           // Access to additional options like Maintenance, Reach Us, and More
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: screenWidth * 0.03,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Row(
//                                   children: [
//                                     TextButton.icon(
//                                       onPressed: () {
//                                         maintenanceActionSheet(
//                                           context,
//                                           "Coming Soon....",
//                                           "We are Working to improve your experience with our new mobile app.",
//                                           Icons.person,
//                                           "okay",
//                                         );
//                                       },
//                                       icon: Icon(
//                                         Icons.medical_information,
//                                         color: const Color.fromARGB(
//                                           246,
//                                           4,
//                                           13,
//                                           95,
//                                         ),
//                                       ),
//                                       label: Text(
//                                         'Maintenance',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: screenWidth * 0.035,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     TextButton.icon(
//                                       onPressed: () {
//                                         reachUsActionSheet(
//                                           context,
//                                           "Reach Us...",
//                                           "Whatsapp",
//                                           "ContactUs",
//                                           "BranchLocator",
//                                           Icons.phone,
//                                           Icons.location_pin,
//                                         );
//                                       },
//                                       icon: Icon(
//                                         Icons.movie_creation_rounded,
//                                         color: const Color.fromARGB(
//                                           246,
//                                           4,
//                                           13,
//                                           95,
//                                         ),
//                                       ),
//                                       label: Text(
//                                         'Reach Us',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: screenWidth * 0.035,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     TextButton.icon(
//                                       onPressed: () {
//                                         moreActionSheet(context, 'Okay');
//                                       },
//                                       icon: Icon(
//                                         Icons.more,
//                                         color: const Color.fromARGB(
//                                           246,
//                                           4,
//                                           13,
//                                           95,
//                                         ),
//                                       ),
//                                       label: Text(
//                                         'More',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: screenWidth * 0.035,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           FutureBuilder(
//                             future: getPackageInfo(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return Text(
//                                   'UBI Agri QA - Version ...',
//                                   style: TextStyle(fontSize: 14),
//                                 );
//                               }

//                               return Text(
//                                 'UBI Agri QA - Version ${snapshot.data!['version']}',
//                                 style: TextStyle(fontSize: 14),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       ),
//     );
//   }
// }

// Widget quickLink(double screenHeight, double screenWidth) {
//   return Padding(
//     padding: EdgeInsets.only(bottom: screenHeight * 0.02),

//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               onPressed: () {},
//               icon: SvgPicture.asset(
//                 'assets/Retail_loan.svg',
//                 // width: screenWidth * 0.02,
//                 // height: screenHeight,
//                 width: screenWidth * 0.05,
//                 height: screenHeight * 0.05,
//               ),
//               iconSize: screenWidth * 0.08,
//               color: Colors.amber,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 0),
//               child: Text(
//                 'Retail Loan',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: screenWidth * 0.04,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               onPressed: () {},
//               icon: SvgPicture.asset(
//                 'assets/Agri_Loan.svg',
//                 width: screenWidth * 0.05,
//                 height: screenHeight * 0.05,
//               ),
//               iconSize: screenWidth * 0.08,
//               color: Colors.blue,
//             ),
//             Text(
//               'Agri Loan',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: screenWidth * 0.04,
//               ),
//             ),
//           ],
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               onPressed: () {},
//               icon: SvgPicture.asset(
//                 'assets/MSME.svg',
//                 width: screenWidth * 0.05,
//                 height: screenHeight * 0.05,
//               ),
//               iconSize: screenWidth * 0.07,
//               color: Colors.pink,
//             ),
//             Text(
//               'MSME Loan',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: screenWidth * 0.04,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'package:newsee/Utils/local_biometric.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/globalconfig/bloc/global_config_bloc.dart';
import 'package:newsee/widgets/options_sheet.dart';
import '../../../feature/forgetmpin/presentation/page/forgetpassword.dart';
import 'maintain.dart';
import 'reachus.dart';
import 'more.dart';
import 'login_mpin.dart';

class LoginpageView extends StatelessWidget {
  Future fingerPrintScanner(context) async {
    final result =
        await GetIt.instance
            .get<BioMetricLogin>()
            .biometricAuthenticationWithKey();
    final user = await loadUser();

    print(
      ' biometric auth response => ${result.message} :: ${result.status} user :: ${user?.LPuserID}',
    );
  }

  Widget renderSettingWidget(BuildContext context, GlobalConfigState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OptionsSheet(
        icon:
            state.globalconfig.operationNetwork == OperationNetwork.online
                ? Icons.signal_wifi_connected_no_internet_4
                : Icons.network_wifi,
        title:
            state.globalconfig.operationNetwork == OperationNetwork.online
                ? "Enable Offline Mode"
                : "Enable Online Mode",
        subtitle: "Hassle-free Lead Onboarding",
        onTap: () {
          if (state.globalconfig.operationNetwork == OperationNetwork.online) {
            context.read<GlobalConfigBloc>().add(
              NetworkChangedEvent(
                Globalconfig.fromValue(network: OperationNetwork.offline),
              ),
            );
          } else {
            context.read<GlobalConfigBloc>().add(
              NetworkChangedEvent(
                Globalconfig.fromValue(network: OperationNetwork.online),
              ),
            );
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF4F6FA), // fallback color
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4F6FA), Color(0xFFE9ECF5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<GlobalConfigBloc, GlobalConfigState>(
          listener: (context, state) {},
          builder:
              (context, state) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),

                      // BRAND HEADER
                      Column(
                        children: const [
                          Text(
                            "UBI Agri",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF040D5F),
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Smart Banking for Agriculture",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      // LOGIN CARD
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 28,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF040D5F),
                              ),
                            ),

                            const SizedBox(height: 30),

                            ElevatedButton.icon(
                              onPressed: () => fingerPrintScanner(context),
                              icon: const Icon(Icons.fingerprint, size: 30),
                              label: const Text("Fingerprint Login"),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFFF1F3F9),
                                foregroundColor: const Color(0xFF040D5F),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            ElevatedButton.icon(
                              onPressed: () {
                                loginActionSheet(
                                  context,
                                  state.globalconfig.operationNetwork,
                                  createMPIN: false,
                                );
                              },
                              icon: const Icon(Icons.login, size: 26),
                              label: const Text("Login with Account"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF040D5F),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            OutlinedButton.icon(
                              onPressed: () => mpin(context, null),
                              icon: const Icon(Icons.lock, size: 26),
                              label: const Text("Login with M-PIN"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF040D5F),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF040D5F),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    forgetActionSheet(
                                      context,
                                      "Reset mPIN",
                                      "Do you want to reset your mPIN?",
                                      Icons.lock_reset,
                                      "Reset",
                                      "Cancel",
                                    );
                                  },
                                  child: const Text(
                                    "Forget M-PIN?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
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
                                  child: const Text(
                                    "Reach Us",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 36),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    maintenanceActionSheet(
                                      context,
                                      "Coming Soon....",
                                      "We are working to improve your experience.",
                                      Icons.person,
                                      "Okay",
                                    );
                                  },
                                  child: const Text(
                                    "Maintenance",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => moreActionSheet(context, 'Okay'),
                                  child: const Text(
                                    "More",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 28,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: FutureBuilder(
                          future: getPackageInfo(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.hasData
                                  ? 'UBI Agri QA - Version ${snapshot.data!['version']}'
                                  : 'UBI Agri QA - Version ...',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
