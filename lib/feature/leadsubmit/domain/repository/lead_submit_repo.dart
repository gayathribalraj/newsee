import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';

abstract class LeadSubmitRepo {
  Future<AsyncResponseHandler<Failure, Map<String, dynamic>>> submitLead({
    required Map<String, dynamic> request,
  });
}
