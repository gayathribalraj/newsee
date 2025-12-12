part of 'query_bloc.dart';

abstract class QueryEvent {
  const QueryEvent();
}

// Fetch the list of queries (Inbox)
class FetchQueryInboxEvent extends QueryEvent {
  const FetchQueryInboxEvent();
}

// Fetch details of a single query
class FetchQueryDetailsEvent extends QueryEvent {
  final String queryId;
  const FetchQueryDetailsEvent({required this.queryId});
}
