import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';

abstract class LandHoldingRepository {
  Future<void> submitLandHolding(LandHoldingRequest request);
}
