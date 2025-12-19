import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/queryInbox/domain/modal/queryInbox_request_modal.dart';
import 'package:newsee/feature/queryInbox/domain/modal/queryInbox_response_modal.dart';
import 'package:newsee/feature/queryInbox/domain/modal/query_request_modal.dart';
import 'package:newsee/feature/queryInbox/domain/modal/query_response_modal.dart';

abstract class QueryRepository {
  Future<AsyncResponseHandler<Failure, QueryInboxResponseModal>>
  getQueryInboxList(QueryInboxRequestModal req);

  Future<AsyncResponseHandler<Failure, QueryResponseModal>>
  getQueryResponseList(QueryRequestModal req);
}
