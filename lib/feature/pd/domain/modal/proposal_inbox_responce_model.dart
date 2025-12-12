// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:newsee/feature/proposal_inbox/domain/modal/group_proposal_inbox.dart';

class ProposalInboxResponseModel {
  final List<GroupProposalInbox> proposalDetails;
  final int totalProposals;

  ProposalInboxResponseModel({
    required this.proposalDetails,
    required this.totalProposals,
  });

  ProposalInboxResponseModel copyWith({
    List<GroupProposalInbox>? proposalDetails,
    int? totalProposals,
  }) {
    return ProposalInboxResponseModel(
      proposalDetails: proposalDetails ?? this.proposalDetails,
      totalProposals: totalProposals ?? this.totalProposals,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proposalDetails': proposalDetails.map((x) => x.toMap()).toList(),
      'totalProposals': totalProposals,
    };
  }

  factory ProposalInboxResponseModel.fromMap(Map<String, dynamic> map) {
    return ProposalInboxResponseModel(
      proposalDetails: List<GroupProposalInbox>.from((map['proposalDetails'] as List<int>).map<GroupProposalInbox>((x) => GroupProposalInbox.fromMap(x as Map<String,dynamic>),),),
      totalProposals: map['totalProposals'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProposalInboxResponseModel.fromJson(String source) => ProposalInboxResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProposalInboxResponseModel(proposalDetails: $proposalDetails, totalProposals: $totalProposals)';

  @override
  int get hashCode => proposalDetails.hashCode ^ totalProposals.hashCode;
}
