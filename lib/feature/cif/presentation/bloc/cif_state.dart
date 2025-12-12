/* 
@author     : latha  23/10/2025
@desc       : State Object for CIF Search
@param      : {CifStatus status} - enum for Fetch status 
              {String errorMessage} - error message when service failure
              {CifResponseModel cifResponseModel} - return CifResponseModel
 */

part of 'cif_bloc.dart';

enum CifStatus { initial, loading, success, failure }

class CifState extends Equatable {
  final CifStatus? status;
  final CifResponseModel? cifResponseModel;

  const CifState({this.status, this.cifResponseModel});

  factory CifState.init() => const CifState(status: CifStatus.initial);

  CifState copyWith({CifStatus? status, CifResponseModel? cifResponseModel}) {
    return CifState(
      status: status ?? this.status,
      cifResponseModel: cifResponseModel ?? this.cifResponseModel,
    );
  }

  @override
  List<Object?> get props => [status, cifResponseModel];
}
