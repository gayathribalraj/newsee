import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:newsee/feature/draft/draft_event_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsee/feature/draft/domain/draft_lead_model.dart';

class DraftService {
  static const String _draftKeyPrefix = 'draft_';
  static String leadref = '';

  Future<void> saveOrUpdateTabData({
    String? leadrefOverride,
    required String tabKey,
    required dynamic tabData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    print('leadref: $leadrefOverride, $tabData');

    if (tabKey == 'loan') {
      leadref = DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      leadref = leadrefOverride ?? leadref;
    }

    final key = '$_draftKeyPrefix$leadref';

    // load existing data or create a new structure
    Map<String, dynamic> currentData;
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      currentData = jsonDecode(jsonString) as Map<String, dynamic>;
    } else {
      final String formattedDateTime = DateFormat(
        'dd-MM-yyyy HH:mm:ss',
      ).format(DateTime.now());
      currentData = {
        'leadref': leadref,
        'createdOn': formattedDateTime,
        'loan': {},
        'dedupe': {},
        'personal': {},
        'address': {},
        'coapplicant': <Map<String, dynamic>>[],
      };
    }

    if (tabKey == 'coapplicant') {
      if (tabData is Map<String, dynamic>) {
        currentData[tabKey] = [tabData];
      } else if (tabData is List) {
        currentData[tabKey] =
            tabData
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
                )
                .toList();
        print('drafsavecoapp: ${currentData[tabKey]}');
      } else {
        currentData[tabKey] = <Map<String, dynamic>>[];
      }
    } else {
      if (tabData is Map<String, dynamic>) {
        currentData[tabKey] = tabData;
      } else {
        currentData[tabKey] = {};
      }
    }

    await prefs.setString(key, jsonEncode(currentData));
    print('drafsave: $currentData');
    draftEventNotifier.refresh();
  }

  Future<DraftLead?> getDraft(String leadref) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_draftKeyPrefix$leadref';
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;
    print('getDraft:  $jsonString ');
    final draftmap = jsonDecode(jsonString) as Map<String, dynamic>;
    print('draft sting to map => $draftmap');
    return DraftLead.fromJson(draftmap);
  }

  Future<void> deleteDraft(String leadref) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_draftKeyPrefix$leadref';
    await prefs.remove(key);
    draftEventNotifier.refresh();
  }

  //get list of all leadrefs with saved drafts
  Future<List<String>> getAllDraftLeadRefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('datadraft:  $keys');
    return keys
        .where((k) => k.startsWith(_draftKeyPrefix))
        .map((k) => k.replaceFirst(_draftKeyPrefix, ''))
        .toList();
  }

  //return currently active leadref
  String getCurrentLeadRef() {
    return leadref;
  }
}
