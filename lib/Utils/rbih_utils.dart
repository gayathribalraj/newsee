import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/offline_data_provider.dart';

List<Map<String, dynamic>>? ownerData;
List<Map<String, dynamic>>? mortgageDetailsList;
List<Map<String, dynamic>>? cropYieldDetailsList;

Future<void> loadRBIHData() async {
  try {
    final response = await offlineDataProvider(
      path: AppConstants.rhIHLandCropResponse,
    );
    final jsonData = response.data;
    final data = jsonData['data']['data'] as Map<String, dynamic>;

    print("_loadData response $response");
    // Assuming the JSON structure has these keys

    final List<dynamic> landOwnerDetails =
        response.data['data']['data']['landOwnerDetails'];

    ownerData =
        (landOwnerDetails as List<dynamic>?)
            ?.map((item) => item as Map<String, dynamic>)
            .toList() ??
        [];

    final List<dynamic> mortageData =
        response
            .data['data']['data']['farmRiskParams']['mortgageDetails']['addlremarks'];

    mortgageDetailsList =
        (mortageData as List<dynamic>?)
            ?.map((item) => item as Map<String, dynamic>)
            .toList() ??
        [];

    final List<dynamic> cryieldDetails =
        response.data['data']['data']['cropYieldDetails']['cropDetail'];

    cropYieldDetailsList =
        (cryieldDetails as List<dynamic>?)
            ?.map((item) => item as Map<String, dynamic>)
            .toList() ??
        [];
  } catch (e) {
    print('Error loading data: $e');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Error loading data: $e')),
    // );
  }
}
