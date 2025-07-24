// ignore_for_file: public_member_api_docs, sort_constructors_first
part of './address_details_bloc.dart';

class AddressDetailsState extends Equatable {
  final List<Lov>? lovList;
  final List<GeographyMaster>? stateCityMaster;
  final List<GeographyMaster>? cityMaster;
  final List<GeographyMaster>? districtMaster;
  final AddressData? addressData;
  final SaveStatus? status;
  final bool? getLead;

  AddressDetailsState({
    required this.addressData,
    required this.lovList,
    required this.stateCityMaster,
    required this.cityMaster,
    required this.districtMaster,
    required this.status,
    this.getLead
  });

  factory AddressDetailsState.init() => AddressDetailsState(
    addressData: null,
    status: SaveStatus.init,
    lovList: [],
    stateCityMaster: [],
    cityMaster: [],
    districtMaster: [],
    getLead: false
  );

  @override
  List<Object?> get props => [
    lovList,
    addressData,
    status,
    stateCityMaster,
    cityMaster,
    districtMaster,
    getLead
  ];

  AddressDetailsState copyWith({
    List<Lov>? lovList,
    AddressData? addressData,
    SaveStatus? status,
    List<GeographyMaster>? stateCityMaster,
    List<GeographyMaster>? cityMaster,
    List<GeographyMaster>? districtMaster,
    bool? getLead
  }) {
    return AddressDetailsState(
      lovList: lovList ?? this.lovList,
      addressData: addressData ?? this.addressData,
      status: status ?? this.status,
      stateCityMaster: stateCityMaster ?? this.stateCityMaster,
      cityMaster: cityMaster ?? this.cityMaster,
      districtMaster: districtMaster ?? this.districtMaster,
      getLead: getLead ?? this.getLead
    );
  }
}