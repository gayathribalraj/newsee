import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'package:newsee/Utils/app_theme_utils.dart';
import 'package:newsee/Utils/convert_mpin.dart';
import 'package:newsee/Utils/masterversioncheck.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/creatempin/presentation/page/create_mpin.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:newsee/widgets/sysmo_mpin.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/*
@author : Gayathri B    09/05/2025
@description : This function displays a custom modal bottom sheet that serves as an MPIN 
              (Mobile Personal Identification Number) entry interface. It includes:
              - A fingerprint icon for biometric authentication.
              - Four TextFields for entering a numeric MPIN.
              - A button to navigate to the Master Download page for checking progress.

@props      :
  - BuildContext context : The context in which the modal bottom sheet is displayed.
*/

mpin(
  BuildContext context,
  AsyncResponseHandler? masterVersionCheckResponseHandler,
) {
  // show the custom modal bottom sheet
  String pin = '';

  showModalBottomSheet<void>(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext context) {
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;

      return SysmoMpin(
        masterVersionCheckResponseHandler: masterVersionCheckResponseHandler,
      );
    },
  );
}
