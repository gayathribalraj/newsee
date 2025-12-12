import 'dart:convert';

import 'package:collection/collection.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

// to be converted  as Data class with fields

class GroupLeadInbox {
  final Map<String, dynamic>? finalList;
  GroupLeadInbox({this.finalList});

  GroupLeadInbox copyWith({Map<String, dynamic>? finalList}) {
    return GroupLeadInbox(finalList: finalList ?? this.finalList);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'finalList': finalList};
  }

  factory GroupLeadInbox.fromMap(Map<String, dynamic>? map) {
    return GroupLeadInbox(finalList: Map<String, dynamic>.from(map! as Map));
  }

  String toJson() => json.encode(toMap());

  factory GroupLeadInbox.fromJson(String source) =>
      GroupLeadInbox.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupLeadInbox(finalList: $finalList)';

  @override
  bool operator ==(covariant GroupLeadInbox other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return mapEquals(other.finalList, finalList);
  }

  @override
  int get hashCode => finalList.hashCode;
}
