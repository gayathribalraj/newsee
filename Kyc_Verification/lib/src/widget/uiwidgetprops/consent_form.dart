import 'package:flutter/material.dart';
import 'package:kyc_verification/src/Utils/service.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/otp_validation.dart';

class ConsentForm extends StatefulWidget {
  final String aadhaarmethod;
  final String aadhaarNumber;
  final String assetPath;
  final String url;
  const ConsentForm({
    super.key,
    required this.aadhaarmethod,
    required this.aadhaarNumber,
    required this.assetPath,
    required this.url,
  });

  @override
  State<ConsentForm> createState() => _ConsoultFormState();
}

class _ConsoultFormState extends State<ConsentForm> {
  bool isChecked = false;
  String inputForm = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),

              buildParagraph(
                "The following definitions apply throughout this Agreement unless otherwise stated:",
              ),

              SizedBox(height: 10),
              buildParagraph(
                'a) Any expression, which has not been defined in this Agreement but is defined in the General Clauses Act, 1897 shall have the same meaning thereof.',
              ),

              SizedBox(height: 10),
              buildParagraph(
                "b) The reference to masculine gender shall be deemed to include reference to feminine gender and vice versa. The meaning of defined terms shall be equally applicable to both the singular and plural forms of the terms defined.",
              ),
              SizedBox(height: 10),
              buildParagraph(
                "c) The word herein hereto, hereunder and the like mean and refer to this Agreement or any other document as a whole and not merely to the specific article, section, subsection, paragraph or clause in which the respective word appears.",
              ),
              SizedBox(height: 10),

              buildParagraph(
                "d) The words including and include shall be deemed to be followed by the words without limitation.",
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) => {
                      setState(() {
                        isChecked = value ?? false;
                      }),
                    },
                  ),
                  SizedBox(width: 10),
                  Text('I Agree terms & condition'),
                ],
              ),
              widget.aadhaarmethod == 'otp'
                  ? ElevatedButton(
                      onPressed: () async {
                        if (isChecked == true) {
                          final response = await KYCService().verify(
                            isOffline: true,
                            request: widget.aadhaarNumber,
                            assetPath: 'assets/data/otpvalidation.json',
                            url: '',
                          );
                          setState(() {
                            isLoading = true;
                          });
                          debugPrint("final OTPSheet Data $response");
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            isLoading = false;
                          });

                          if (response != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("OTP Send Successfully!!!"),
                              ),
                            );
                            await Future.delayed(const Duration(seconds: 2));

                            final optionOTPSheet = await showOtpBottomSheet(
                              context,
                              widget.assetPath,
                              widget.url,
                            );
                            await Future.delayed(const Duration(seconds: 1));

                            setState(() {
                              isLoading = false;
                            });
                            debugPrint("final OTPSheet Data $optionOTPSheet");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("OTP Generate failed!!!")),
                            );
                          }

                          // Navigator.pop(context);
                        }
                      },
                      child: isLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('OTP Verification'),
                    )
                  : ElevatedButton(
                      onPressed: () async {},
                      child: Text('Bio-Metric'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper UI Component for repeated text blocks
Widget buildParagraph(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Text(text, style: TextStyle(fontSize: 15, height: 1.4)),
  );
}
