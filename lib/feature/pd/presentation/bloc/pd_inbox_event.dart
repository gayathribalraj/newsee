part of 'pd_inbox_bloc.dart';

abstract class PDInboxEvent {
  const PDInboxEvent();
}
// bloc event type that will be called when Login button clicked

class SearchProposalInboxEvent extends PDInboxEvent {
  final LeadInboxRequest request;

  const SearchProposalInboxEvent({required this.request});
}

class ApplicationStatusCheckEvent extends PDInboxEvent {
  final Map<String, dynamic> currentApplication;
  const ApplicationStatusCheckEvent({required this.currentApplication});
}

class PDInboxFetchEvent extends PDInboxEvent {
  final PdInboxRequest request;

  const PDInboxFetchEvent({required this.request});
}
