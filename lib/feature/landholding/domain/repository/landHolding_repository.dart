import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';

abstract class LandHoldingRepository {
  Future<AsyncResponseHandler<Failure, List<GroupLeadInbox>>> landHolding(
    LandHoldingRequest req,
  );
}
