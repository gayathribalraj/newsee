import 'package:newsee/blocs/cif/domain/model/user/cif_response_model.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';

abstract class CifRepository {
  Future<AsyncResponseHandler<Failure, CifResponseModel>> searchCif(
    Map<String, dynamic> req,
  );
}
