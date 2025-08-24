import 'package:equatable/equatable.dart';

abstract class DairyDetailsEvent  {
  const DairyDetailsEvent();

}

class AddDetails extends DairyDetailsEvent {
  final Map<String, dynamic> detail;
  const AddDetails(this.detail);

  
}

class DeleteDetails extends DairyDetailsEvent {
  final int index;
  const DeleteDetails(this.index);

 
}

class DairyDetailsFailed extends DairyDetailsEvent {
  final String error;
  const DairyDetailsFailed(this.error);

}
