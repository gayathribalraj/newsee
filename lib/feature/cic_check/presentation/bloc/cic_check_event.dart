abstract class CicCheckEvent {
  const CicCheckEvent();
}

class CicFetchEvent extends CicCheckEvent {
  final Map<String, dynamic>? proposalData;
  final String? applicantType;
  final String? reportType;
  const CicFetchEvent({this.proposalData, this.reportType, this.applicantType});
}

class CibilDataFetchFromDBEvent extends CicCheckEvent {
  final String proposal;
  final bool? cibilStatu;
  CibilDataFetchFromDBEvent({required this.proposal, this.cibilStatu});
}
