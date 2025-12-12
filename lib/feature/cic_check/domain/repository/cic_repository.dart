import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_response_model.dart';
import 'package:newsee/feature/cic_check/domain/modals/cic_request.dart';

abstract class CicRepository {
  Future<AsyncResponseHandler<Failure, CibilResponse>> searchCibil(
    CICRequest req,
  );
}
