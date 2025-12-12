/*
  @author   : Gayathri
  @created  : 12/11/2025
  @desc     : Reusable showOtpBottomSheet 
*/

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:kyc_verification/src/Utils/service.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/sysmo_alert.dart';
Future showOtpBottomSheet(BuildContext context, path, url) async {
  late String otpPin = '';

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 30,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter OTP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            OtpTextField(
              numberOfFields: 6,
              showFieldAsBox: true,
              fieldWidth: 45,
              filled: true,
              fillColor: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              onCodeChanged: (value) {
                otpPin = value;
              },

              onSubmit: (value) {
                otpPin = value;
              },
            ),

            const SizedBox(height: 20),

            // Verify OTP button
            ElevatedButton(
              onPressed: () async {
                //  If OTP not complete  don't close, don't success
                if (otpPin.length != 6) {
                  isLoading.value = false;
                  SysmoAlert.failure(message: "Please enter valid 6-digit OTP");
                  return;
                }

                //  OTP is valid start loading
                isLoading.value = true;

                await Future.delayed(Duration(seconds: 1));

                final response = await KYCService().verify(
                  isOffline: true,
                  request: otpPin,
                  assetPath: path,
                  url: url,
                );

                isLoading.value = false;

                // Close sheet & return response to previous screen
                Navigator.pop(context);
                Navigator.pop(context, response);
              },

              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: const Color.fromARGB(255, 3, 9, 110),
                foregroundColor: Colors.white,
              ),

              child: ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, _) {
                  return value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text("Verify OTP");
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}


Future showValidateOptions(BuildContext context) async {
  BuildContext ctx = context;
  return await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        height: 180,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.qr_code_scanner),
              title: Text('Biometric'),
              onTap: () {
                Navigator.pop(context, 'bio');
              },
            ),
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('OTP'),
              onTap: () {
                Navigator.pop(context, 'otp');
              },
            ),
          ],
        ),
      );
    },
  );
}
