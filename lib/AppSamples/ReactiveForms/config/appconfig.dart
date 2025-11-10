import 'package:newsee/Utils/validators_api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppConfig {
  final loginFormgroup = FormGroup({
    'username': FormControl(
      value: '',
      validators: [
        Validators.required,
        Validators.delegate(checkForRestrictedSpecialChars),
      ],
    ),
    'password': FormControl(
      value: '',
      validators: [
        Validators.required,
        // Validators.pattern(AppConstants.PATTERN_SPECIALCHAR),
      ],
    ),
  });
}
