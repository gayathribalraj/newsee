/*
  @author   : Gayathri
  @created  : 08/11/2025
  @desc     : A reusable and reactive input field for user verification workflows (Voter/Aadhaar)
  Handles both online and offline verification ,
  Displays dynamic button states for verification results,
  Supports validation, error display, and OTP verification
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kyc_verification/src/AppData/app_constants.dart';
import 'package:kyc_verification/src/widget/kyc_verification.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/button_props.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/consent_form.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/otp_validation.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/pan_request.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/panid_service.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/voterid_request.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/voterid_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'form_props.dart';
import 'style_props.dart';

// type of verification handle by KYCTextBox

enum VerificationType { voter, aadhaar, pan }

/// code review comments
/// 1. Added null safety to onChange callback.
/// 2. Used widget.styleProps.padding with a default value of EdgeInsets.zero to avoid null issues.
/// 3. Used widget.styleProps.textStyle with a default TextStyle to ensure consistent styling.
/// 4. Improved validationMessages to handle null validator gracefully.
/// 5. Added comments for better code understanding.
/// 6. Ensured proper formatting and indentation for better readability.
/// 7. Used const constructors where applicable for better performance.

// Voter Verification UI A wrapper widget for voter ID verification input using KYCTextBox

class VoterVerification extends StatefulWidget {
  final KYCTextBox kycTextBox;
  VoterVerification({super.key, required this.kycTextBox});

  @override
  State<StatefulWidget> createState() => _VoterVerificationState();
}

class _VoterVerificationState extends State<VoterVerification> {
  @override
  Widget build(BuildContext context) {
    return widget.kycTextBox;
  }
}

// Aadhaar Verification UI A wrapper widget for Aadhaar  verification input using KYCTextBox
class AadhaarVerification extends StatefulWidget {
  final KYCTextBox kycTextBox;
  AadhaarVerification({super.key, required this.kycTextBox});

  @override
  State<StatefulWidget> createState() => _AadhaarVerificationState();
}

class _AadhaarVerificationState extends State<AadhaarVerification> {
  @override
  Widget build(BuildContext context) {
    return widget.kycTextBox;
  }
}

class PanVerification extends StatefulWidget {
  final KYCTextBox kycTextBox;
  PanVerification({super.key, required this.kycTextBox});

  @override
  State<StatefulWidget> createState() => _PanVerificationState();
}

class _PanVerificationState extends State<PanVerification> {
  @override
  Widget build(BuildContext context) {
    return widget.kycTextBox;
  }
}

//KYCTextBox Widget uses ReactiveTextField for reactive form integration.

class KYCTextBox extends StatefulWidget {
  final FormProps formProps;
  final StyleProps styleProps;
  final ButtonProps buttonProps;
  final bool isOffline;
  final String? assetPath;
  final String apiUrl;
  final ValueChanged<dynamic> onSuccess;
  final ValueChanged<dynamic> onError;
  final Key? fieldKey;
  final String? validationPattern;
  final VerificationType verificationType;
  final String? kycNumber;

  final ReactiveFormFieldCallback<String>? onChange;
  bool showVerifyButton;
  KYCTextBox({super.key, 
    this.fieldKey,
    required this.formProps,
    required this.styleProps,
    this.showVerifyButton = false,
    this.onChange,
    required this.buttonProps,
    required this.isOffline,
    this.assetPath,
    required this.onSuccess,
    required this.onError,
    this.validationPattern,
    required this.apiUrl,
    required this.verificationType,
    this.kycNumber,
  });

  @override
  State<StatefulWidget> createState() => _KYCTextBoxState();
}

// _KYCTextBoxState — Handles UI logic, verification, and state updates
class _KYCTextBoxState extends State<KYCTextBox> with VerificationMixin {
  bool isLoading = false;
  bool isSuccess = false;
  bool isError = false;
  String buttonText = '';
  String id = '';
  bool isValid = true;
  final voterIdPattern = AppConstants.VOTERID_PATTERN;
  final aadhaPattern = AppConstants.AADHAAR_PATTERN;
  final panPattern = AppConstants.PAN_PATTERN;
  String apiUrl = '';
  bool disabled = false;

  @override
  void initState() {
    super.initState();

    if (widget.kycNumber != null && widget.kycNumber!.isNotEmpty) {
      print("widget.kycNumber => ${widget.kycNumber}");
      print("widget.kycNumber.isNotEmpty => ${widget.kycNumber!.isNotEmpty}");
      setState(() {
        isValid = true;
        isSuccess = true;
        buttonText = 'verified';
        disabled = true;
      });
    } else {
      setState(() {
        buttonText = widget.buttonProps.label;
      });
    }
  }

  // Determines the background color of the Verify button based on the state.
  Color? buttonBackgroundColor() {
    if (isLoading) return Colors.grey;
    if (isSuccess) return Colors.green;
    if (isError) return Colors.red;
    return widget.buttonProps.backgroundColor ?? Color.fromARGB(255, 3, 9, 110);
  }

  //  method to handle input verification (API or offline asset).
  Future verifyInput(String input) async {
    setState(() {
      isLoading = true;
      isSuccess = false;
      isError = false;
    });

    try {
      // Perform verification using either online API or offline asset.

      final response = await verify(
        isOffline: widget.isOffline,
        url: widget.apiUrl,
        assetPath: widget.assetPath,
      );

      //  success callback

      widget.onSuccess(response);

      setState(() {
        isSuccess = true;
        buttonText = 'Verified';
        disabled = true;
      });
    } catch (e) {
      //  error callback
      widget.onError(e);
      setState(() {
        isError = true;
        buttonText = 'Failed';
        isValid = true;
        disabled = false;
      });
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isLoading = false;
      });
    }
  }

  //Wrapper over VerificationMixins verify(), online/offline verification based on user config.
  @override
  Future<Response> verify({
    required bool isOffline,
    String? url,
    String? assetPath,
  }) async {
    if (isOffline && assetPath != null) {
      return await verifyOffline(assetPath);
    } else if (!isOffline && url != null) {
      return await verifyOnline(url);
    } else {
      throw Exception('No data source provided');
    }
  }

  @override
  Future<Response> verifyOffline(String assetPath) =>
      OfflineVerificationHandler.loadData(assetPath);

  @override
  Future<Response> verifyOnline(String url) async => ApiClient().callGet(url);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // Textbox section Reactive Form field
                IgnorePointer(
                  ignoring: disabled,
                  child: ReactiveTextField<String>(
                    autofocus: false,
                    keyboardType: getKeyboardType(widget.verificationType),
                    formControlName: widget.formProps.formControlName,
                    onChanged: (control) {
                      final raw = (control.value ?? '').toString().trim();
                      id = raw;
                      // Validate pattern for either any kyc
                      isValid =
                          (voterIdPattern.hasMatch(raw) ||
                              aadhaPattern.hasMatch(raw) ||
                              panPattern.hasMatch(raw));
                      //Reset button state when input changes
                      setState(() {
                        buttonText = widget.buttonProps.label;
                        isSuccess = false;
                        isError = false;
                        isValid = isValid;
                        disabled = false;
                      });
                    },
                    maxLength: widget.formProps.maxLength,
                    style:
                        widget.styleProps.textStyle ??
                        const TextStyle(fontSize: 14),
                    decoration:
                        widget.styleProps.inputDecoration ??
                        InputDecoration(
                          label: RichText(
                            text: TextSpan(
                              text: widget.formProps.label,
                              style:
                                  widget.styleProps.textStyle ??
                                  const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                              children: [
                                TextSpan(
                                  text: widget.formProps.mandatory ? ' *' : '',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          // Keep error style under the field.
                          errorStyle:
                              widget.styleProps.textStyle ??
                              TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    validationMessages:
                        widget.formProps.validator != null &&
                                widget.formProps.maxLength != null
                            ? {
                              '': (control) {
                                final abstractControl =
                                    control as AbstractControl<dynamic>;
                                final errorMessage = widget
                                    .formProps
                                    .validator!(abstractControl);
                                return errorMessage;
                              },
                            }
                            : null,
                  ),
                ),
                // Custom validation error message pattern,
                if (!isValid)
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      '${widget.validationPattern}',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          //Verify Button
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (states) => buttonBackgroundColor(),
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                (states) => widget.buttonProps.foregroundColor,
              ),
              padding: WidgetStateProperty.all(widget.buttonProps.padding),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    widget.buttonProps.borderRadius,
                  ),
                ),
              ),
            ),

            onPressed:
                (!isValid || isLoading || disabled)
                    ? null
                    : () async {
                      // Access the  ReactiveForm in the widget tree
                      final formState = ReactiveForm.of(context);

                      // Ensure the form is a valid FormGroup before proceeding
                      if (formState is! FormGroup) return;
                      final input =
                          formState
                              .control(widget.formProps.formControlName)
                              .value;
                      //Stop if input is empty or null
                      if (input == null || input.toString().isEmpty) return;

                      // voterId verification flow
                      if (widget.verificationType == VerificationType.voter) {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(Duration(seconds: 2));

                        //  pass the VoteridRequest
                        final voterRequest = VoteridRequest(
                          epicNo: input.toString(),
                        );
                        // create instance of VoterVerified
                        final voterVerified = VoterVerified();

                        Response response;
                        try {
                          // offline handler
                          if (widget.isOffline) {
                            response = await voterVerified.verifyOffline(
                              widget.assetPath!,
                            );
                          } else {
                            // online  handler

                            response = await voterVerified.verifyOnline(
                              widget.apiUrl,
                              request: voterRequest,
                            );
                          }

                          debugPrint("Voter Response: ${response.data}");

                          final responseData = response.data;

                          bool success = false;

                          if (widget.isOffline) {
                            print("Offline response: $responseData");

                            final decodedResponse = jsonDecode(
                              responseData['RESPONSE'],
                            );
                            debugPrint("decodedResponse $decodedResponse");

                            final status =
                                decodedResponse['ursh']?['status']
                                    ?.toString()
                                    .toUpperCase();
                            final responseCode =
                                decodedResponse['ursh']?['responseCode']
                                    ?.toString();

                            success =
                                (status == 'SUCCESS' && responseCode == '200');
                          } else {
                            print("Online response: $responseData");

                            success =
                                (responseData['status'] == 'SUCCESS' &&
                                    responseData['responseCode'] == '200');
                          }

                          if (success) {
                            print("finally voter id response $response");
                            widget.onSuccess(response);

                            setState(() {
                              isLoading = false;
                              isSuccess = true;
                              isError = false;
                              disabled = true;
                              buttonText = "Verified";
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Voter ID Verified Successfully"),
                              ),
                            );
                          } else {
                            setState(() {
                              isLoading = false;
                              isSuccess = false;
                              isError = true;
                              disabled = false;
                              buttonText = "Failed";
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Voter ID Verification Failed"),
                              ),
                            );
                          }
                        } catch (e) {
                          debugPrint("Voter Error: $e");

                          setState(() {
                            isLoading = false;
                            isSuccess = false;
                            isError = true;
                            disabled = false;
                            buttonText = "Failed";
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Voter Verification Failed"),
                            ),
                          );
                        }
                      }

                      // panNumber verification flow
                      if (widget.verificationType == VerificationType.pan) {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(Duration(seconds: 2));

                        //  pass the panidRequest
                        final panRequest = PanidRequest(pan: input.toString());
                        // create instance of VoterVerified
                        final panVerified = PanVerified();

                        Response response;
                        try {
                          // offline handler
                          if (widget.isOffline) {
                            response = await panVerified.verifyOffline(
                              widget.assetPath!,
                            );
                          } else {
                            // online  handler

                            response = await panVerified.verifyOnline(
                              widget.apiUrl,
                              request: panRequest,
                            );
                          }

                          debugPrint("panVerified Response: ${response.data}");

                          final responseData = response.data;

                          bool success = false;

                          if (widget.isOffline) {
                            print("Offline response: $responseData");
                            try {
                              final panValidation =
                                  responseData["PanValidation"];
                              success =
                                  (responseData["Success"] == true) &&
                                  (panValidation != null) &&
                                  (panValidation["success"] == true);
                            } catch (error) {
                              debugPrint('$error');
                              success = false;
                            }
                          }
                          if (success) {
                            print("finally pan id response $responseData");
                            widget.onSuccess(responseData);

                            setState(() {
                              isLoading = false;
                              isSuccess = true;
                              isError = false;
                              disabled = true;
                              buttonText = "Verified";
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Pan ID Verified Successfully"),
                              ),
                            );
                          } else {
                            widget.onError(response);

                            setState(() {
                              isLoading = false;
                              isSuccess = false;
                              isError = true;
                              disabled = false;
                              buttonText = "Failed";
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("PAN Verification Failed"),
                              ),
                            );
                          }
                        } catch (e) {
                          debugPrint("PAN Error: $e");

                          widget.onError(e);
                          setState(() {
                            isLoading = false;
                            isSuccess = false;
                            isError = true;
                            disabled = false;
                            buttonText = "Failed";
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PAN Verification Failed")),
                          );
                        }
                      }

                      // Aadhaar verification flow

                      if (widget.verificationType == VerificationType.aadhaar) {
                        final methodType = await showValidateOptions(context);

                        // select methodtype null means this condition failed
                        if (methodType == null) {
                          return;
                        }

                        // get the consentResponse form value
                        final consentResponse = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ConsentForm(
                                  aadhaarNumber: input.toString(),
                                  aadhaarmethod: methodType,
                                  assetPath: widget.assetPath ?? '',
                                  url: widget.apiUrl,
                                ),
                          ),
                        );
                        debugPrint("Consent Response: $consentResponse");
                        debugPrint(
                          "Consent Response123: ${consentResponse.data}",
                        );
                        debugPrint(
                          "Consent Successfinal: ${consentResponse.data['Success']}",
                        );
                        final bool success = consentResponse.data['Success'];
                        // update button based on success or failure
                        if (success) {
                          widget.onSuccess(consentResponse);
                          setState(() {
                            isSuccess = true;
                            disabled = true;
                            buttonText = "Verified";
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Aadhaar ID Verified Successfully",
                                ),
                              ),
                            );
                          });
                        } else {
                          widget.onError(consentResponse);
                          setState(() {
                            isError = true;
                            disabled = true;
                            buttonText = "Failed";
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Aadhaar ID Verified Failed"),
                              ),
                            );
                          });
                        }
                      }
                    },
            child:
                isLoading
                    ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(buttonText),
          ),
        ],
      ),
    );
  }
}

TextInputType getKeyboardType(VerificationType type) {
  switch (type) {
    case VerificationType.aadhaar:
      return TextInputType.number;

    case VerificationType.pan:
    case VerificationType.voter:
      return TextInputType.text;

    default:
      return TextInputType.text;
  }
}
