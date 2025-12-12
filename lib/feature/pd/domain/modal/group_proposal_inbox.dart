// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class GroupProposalInbox {
  final Map<String, dynamic> finalList;
  GroupProposalInbox({
    required this.finalList,
  });

  GroupProposalInbox copyWith({
    Map<String, dynamic>? finalList,
  }) {
    return GroupProposalInbox(
      finalList: finalList ?? this.finalList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'finalList': finalList,
    };
  }

  factory GroupProposalInbox.fromMap(Map<String, dynamic>? map) {
    return GroupProposalInbox(
      finalList: Map<String, dynamic>.from(map! as Map),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupProposalInbox.fromJson(String source) =>
      GroupProposalInbox.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupProposalInbox(finalList: $finalList)';

  @override
  bool operator ==(covariant GroupProposalInbox other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;
  
    return 
      mapEquals(other.finalList, finalList);
  }

  @override
  int get hashCode => finalList.hashCode;
}
