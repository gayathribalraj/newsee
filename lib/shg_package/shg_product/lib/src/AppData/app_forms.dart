import 'package:reactive_forms/reactive_forms.dart';

class AppForms {
  static FormGroup shgForm() => FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
    'primaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'email': FormControl<String>(validators: [Validators.email]),

    'loanAmountRequested': FormControl<String>(
      validators: [Validators.required],
      asyncValidators: [
        Validators.delegateAsync((control) async {
          String val = control.value as String;
          int loanAmountEntered = int.parse(
            val.replaceAll(RegExp(r'[^\d]'), ''),
          );
          // if (loanAmountEntered > Globalconfig.loanAmountMaximum) {
          //   print(
          //     'loanAmountRequested::delegateAsync => ${Globalconfig.loanAmountMaximum}',
          //   );
          //   return {'max': '${Globalconfig.loanAmountMaximum}'};
          // }
          // return null;
        }),
      ],
    ),
    'natureOfActivity': FormControl<String>(validators: []),
    'agriculturistType': FormControl<String>(validators: []),
    'religion': FormControl<String>(validators: []),
    'gender': FormControl<String>(validators: []),
  });
}
