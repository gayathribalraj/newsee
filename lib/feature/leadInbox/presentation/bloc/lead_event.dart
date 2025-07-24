part of 'lead_bloc.dart';

abstract class LeadEvent {
  const LeadEvent();
}
// bloc event type that will be called when Login button clicked

class SearchLeadEvent extends LeadEvent {
  final int pageNo;
  final int pageCount;
  const SearchLeadEvent({this.pageNo = 0, this.pageCount = 20});
}

class CreateProposalLeadEvent extends LeadEvent {
  final String leadId;
  const CreateProposalLeadEvent({required this.leadId});
}

class GetLeadDataEvent extends LeadEvent {
  final String leadId;
  const GetLeadDataEvent({required this.leadId});
}
