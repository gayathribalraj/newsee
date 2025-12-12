import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/group_proposal_inbox.dart';
import 'package:package_info_plus/package_info_plus.dart';

String formatAmount(String amount, [String? type]) {
  try {
    print('amount: $amount');
    final num value = num.parse(amount);
    if (type == null || type.isEmpty) {
      final formatter = NumberFormat.decimalPattern('en_IN');
      return formatter.format(value);
    } else {
      // return '₹${formatter.format(value)}';
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '',
        decimalDigits: 2,
      );
      return formatter.format(value).trim();
    }
  } catch (e) {
    print('amountformate: $e');
    return amount;
  }
}

// Convert CIF Response Date to String Date(dd-MM-yyyy);
// String getDateFormat(dynamic value) {
//   if (value == null || value.toString().trim().isEmpty) return "";

//   final formats = [
//     DateFormat("dd-MM-yyyy"),
//     DateFormat("yyyy-MM-dd"),
//     DateFormat("MMM dd, yyyy, hh:mm:ss a"),
//   ];

//   for (var format in formats) {
//     try {
//       final date = format.parse(value.toString());
//       return DateFormat('dd-MM-yyyy').format(date);
//     } catch (e) {
//       print('dat: $e');
//     }
//   }
//   return "";
// }

String getDateFormat(dynamic value) {
  if (value == null) return "";
  final input = value.toString().trim();
  if (input.isEmpty) return "";

  final List<DateFormat> formats = [
    DateFormat("dd-MM-yyyy"),
    DateFormat("yyyy-MM-dd"),
    DateFormat("dd/MM/yyyy"),
    DateFormat("yyyy/MM/dd"),
    DateFormat("MMM dd, yyyy"),
    DateFormat("MMM dd, yyyy, hh:mm:ss a"),
    DateFormat("yyyy-MM-ddTHH:mm:ss"), // ISO-like
    DateFormat("yyyy-MM-dd HH:mm:ss"),
  ];

  for (final format in formats) {
    try {
      final date = format.parseStrict(input);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      // continue trying next format
    }
  }

  // try a fallback using DateTime.parse (handles many standard formats)
  try {
    final date = DateTime.parse(input);
    return DateFormat('dd-MM-yyyy').format(date);
  } catch (e) {
    print('dateFormate: $e');
    return "";
  }
}

// Convert Aadhaar Response Date to String Date(dd-MM-yyyy);
String getCorrectDateFormat(dynamic value) {
  try {
    DateFormat parser = DateFormat('yyyy-MM-dd');
    DateTime date = parser.parse(value);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String convertedDateString = formatter.format(date);
    return convertedDateString;
  } catch (error) {
    print("getCorrectDateFormat-string $error");
    return "";
  }
}

// Split Aadhaar Address String more than 40 digit and return string data
String? addressSplit(String str) {
  try {
    if (str == "") {
      return str;
    } else {
      if (str[0] == " ") {
        str = str.trim();
      }
      // let first = str.substring(0, 40).lastIndexOf(',')
      String? line1;
      if (str.length < 40) {
        line1 = str;
      } else {
        final first = str.substring(0, 40).lastIndexOf(' ');
        if (first < 0) {
          line1 = str.substring(0);
        } else {
          line1 = str.substring(0, first + 1);
        }
      }
      return line1;
    }
  } catch (error) {
    print("error catching $error");
    return null;
  }
}

/// @desc   : converts date by provided arguments
/// @param  : {from} - date to be formated , {to} will be retured formatted string
/// @return : {String} - formatted date

String getDateFormatedByProvided(
  dynamic value, {
  required String from,
  required String to,
}) {
  try {
    DateFormat parser = DateFormat(from);
    DateTime date = parser.parse(value);
    DateFormat formatter = DateFormat(to);
    String convertedDateString = formatter.format(date);
    return convertedDateString;
  } catch (error) {
    print("getCorrectDateFormat-string $error");
    return "";
  }
}

void showSnack(BuildContext context, {required String message}) {
  // final rootContext = Navigator.of(context, rootNavigator: true).context;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void goToNextTab({required BuildContext context}) {
  final tabController = DefaultTabController.of(context);
  if (tabController.index < tabController.length - 1) {
    tabController.animateTo(tabController.index + 1);
  }
}

CoappDetailsState mapGeographyMasterResponseForCoAppPage(
  CoappDetailsState state,
  AsyncResponseHandler response,
) {
  if (response.isRight()) {
    Map<String, dynamic> resp = response.right as Map<String, dynamic>;

    List<GeographyMaster> cityMaster =
        resp['cityMaster'] != null && resp['cityMaster'].isNotEmpty
            ? resp['cityMaster'] as List<GeographyMaster>
            : [];
    List<GeographyMaster> districtMaster =
        resp['districtMaster'] != null && resp['districtMaster'].isNotEmpty
            ? resp['districtMaster'] as List<GeographyMaster>
            : [];
    // map
    return state.copyWith(
      status: SaveStatus.mastersucess,
      cityMaster: cityMaster,
      districtMaster: districtMaster,
    );
  } else {
    return state.copyWith(
      status: SaveStatus.masterfailure,
      cityMaster: [],
      districtMaster: [],
    );
  }
}

AddressDetailsState mapGeographyMasterResponseForAddressPage(
  AddressDetailsState state,
  AsyncResponseHandler response,
) {
  if (response.isRight()) {
    Map<String, dynamic> resp = response.right as Map<String, dynamic>;

    List<GeographyMaster>? cityMaster =
        resp['cityMaster'] != null && resp['cityMaster'].isNotEmpty
            ? resp['cityMaster'] as List<GeographyMaster>
            : state.cityMaster;
    List<GeographyMaster>? districtMaster =
        resp['districtMaster'] != null && resp['districtMaster'].isNotEmpty
            ? resp['districtMaster'] as List<GeographyMaster>
            : state.districtMaster;
    // map
    return state.copyWith(
      status: SaveStatus.mastersucess,
      cityMaster: cityMaster,
      districtMaster: districtMaster,
    );
  } else {
    return state.copyWith(
      status: SaveStatus.masterfailure,
      cityMaster: [],
      districtMaster: [],
    );
  }
}

void closeBottomSheetIfExists(BuildContext context) {
  // Check if the current route is a bottom sheet (ModalBottomSheetRoute)
  if (ModalRoute.of(context)?.isCurrent == true &&
      ModalRoute.of(context) is ModalBottomSheetRoute) {
    // Check if the route can be popped
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

Map<String, String?> nameSeperate(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) {
    return {'firstName': '', 'middleName': '', 'lastName': ''};
  }
  final getNameArray = fullName.trim().split(RegExp(r'\s+'));
  // String fullname = fullName;
  // List getNameArray = fullname.split(' ');
  print('fullName: $getNameArray');

  if (getNameArray.length == 1) {
    return {'firstName': fullName, 'middleName': '', 'lastName': ''};
  } else if (getNameArray.length == 2) {
    return {
      'firstName': getNameArray[0],
      'middleName': '',
      'lastName': getNameArray[1],
    };
  } else {
    return {
      'firstName': getNameArray[0],
      'middleName': getNameArray[1],
      'lastName': getNameArray.sublist(2).join(),
    };
  }
}

CoapplicantData mapCoapplicantDataFromCif(CifResponse response) {
  print('CifResponse $response');
  try {
    String mobileno = '';
    if (response.lleadmobno!.length == 12 &&
        response.lleadmobno!.startsWith("91")) {
      mobileno = response.lleadmobno!.substring(2);
    }
    String? firstName = '';
    String? middleName = '';
    String? lastName = '';
    if (response.lleadfrstname != null && response.lleadfrstname!.isNotEmpty) {
      firstName = response.lleadfrstname;
      middleName = response.lleadmidname;
      lastName = response.lleadlastname;
    } else {
      final result = nameSeperate(response.lleadfrstname);
      firstName = result['firstName'];
      middleName = result['middleName'];
      lastName = result['lastName'];
    }

    CoapplicantData data = CoapplicantData(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      email: response.lleademailid,
      primaryMobileNumber: mobileno != '' ? mobileno : response.lleadmobno,
      panNumber: response.lleadpanno,
      address1: response.lleadaddress,
      address2: response.lleadaddresslane1,
      address3: response.lleadaddresslane2,
      pincode: response.lleadpinno,
      aadharRefNo: response.lleadadharno,
      dob: getDateFormat(response.lleaddob),
      loanLiabilityCount: response.liabilityCount,
      loanLiabilityAmount: response.liabilityAmount,
      depositCount: response.depositCount,
      depositAmount: response.depositAmount,
      // constitution: response.lldGender,
      title: response.lleadtitle,
      gender: response.lldGender,
    );

    print('mapCoapplicantDataFromCif => $data');
    return data;
  } catch (e) {
    print('co-app map: $e');
    return CoapplicantData();
  }
}

/// @desc   : Remove rupee seperator from form value
/// @param  : {from} - String value from form , {to} will be retured removed comma from string value
/// @return : {String} - string data
String removeSpecialCharacters(String? formval) {
  try {
    if (formval == null || formval.isEmpty) return '0';

    // Remove all non-digit characters
    String raw = formval.replaceAll(RegExp(r'[^\d]'), '');

    // Remove trailing "00" if the original value had ".00"
    if (formval.contains('.00') && raw.endsWith('00')) {
      raw = raw.substring(0, raw.length - 2);
    }

    return raw.isEmpty ? '0' : raw;
  } catch (error) {
    print('removeSpecialCharacters-utilspage => $error');
    return '0';
  }
}

List<GroupLeadInbox>? onSearchLeadInbox({
  required List<GroupLeadInbox>? items,
  required String searchQuery,
}) {
  final filteredLeads =
      items?.where((lead) {
        final name = (lead.finalList!['lleadfrstname'] ?? '').toLowerCase();
        final id = (lead.finalList!['lleadid'] ?? '').toLowerCase();
        final phone = (lead.finalList!['lleadmobno'] ?? '').toLowerCase();
        final loan = (lead.finalList!['lldLoanamtRequested'] ?? '').toString();
        return name.contains(searchQuery.toLowerCase()) ||
            id.contains(searchQuery.toLowerCase()) ||
            phone.contains(searchQuery.toLowerCase()) ||
            loan.contains(searchQuery.toLowerCase());
      }).toList();
  return filteredLeads;
}

List<GroupProposalInbox>? onSearchApplicationInbox({
  required List<GroupProposalInbox>? items,
  required String searchQuery,
}) {
  final filteredLeads =
      items?.where((lead) {
        final name = (lead.finalList['lleadfrstname'] ?? '').toLowerCase();
        final propNo = (lead.finalList['propNo'] ?? '').toString();
        final id = (lead.finalList['lleadid'] ?? '').toLowerCase();
        final phone = (lead.finalList['lleadmobno'] ?? '').toLowerCase();
        final loan = (lead.finalList['lldLoanamtRequested'] ?? '').toString();
        return name.contains(searchQuery.toLowerCase()) ||
            propNo.contains(searchQuery.toLowerCase()) ||
            id.contains(searchQuery.toLowerCase()) ||
            phone.contains(searchQuery.toLowerCase()) ||
            loan.contains(searchQuery.toLowerCase());
      }).toList();
  return filteredLeads;
}

String generateUniqueID() {
  // Get current timestamp in milliseconds
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  // Generate random number between 0 and 99999
  final random = Random().nextInt(100000);

  // Combine timestamp and random number, take last 10 digits
  final combined = (timestamp + random).toString();
  return combined.substring(combined.length - 10);
}

Future<Map<String, String>> getPackageInfo() async {
  final info = await PackageInfo.fromPlatform();
  return {
    'appName': info.appName,
    'version': info.version,
    'buildNumber': info.buildNumber,
  };
}

int parseToInt(dynamic value) {
  if (value == null) return 0;

  // If already int
  if (value is int) return value;

  // If it's double — convert to int (floor/round)
  if (value is double) return value.round();

  // If it's String — try parsing
  if (value is String) {
    // Try int parse
    final i = int.tryParse(value);
    if (i != null) return i;

    // Try double parse → then convert to int
    final d = double.tryParse(value);
    if (d != null) return d.round();
  }

  return 0; // default fallback
}
