import 'package:get_it/get_it.dart';
import 'package:newsee/Utils/local_biometric.dart';

final getIt = GetIt.instance;

void dependencyInjection() {
  // getIt.registerSingleton(MediaService());
  getIt.registerSingleton(BioMetricLogin());
  // getIt.registerFactory<CameraBloc>(() => CameraBloc());
  // getIt.registerFactory<LoginBloc>(
  //   () => LoginBloc(loginRequest: LoginRequest(username: '', password: '')),
  // );
  // getIt.registerSingleton<SaveProfilePictureBloc>(
  //   SaveProfilePictureBloc(
  //     ProfilPictureState(status: null, profilepicturedetails: null),
  //   ),
  // );
}
