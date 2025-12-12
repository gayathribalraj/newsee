import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:newsee/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';

class LoginBlocProvide extends StatelessWidget {
  final bool? createPIN;
  final OperationNetwork network;
  const LoginBlocProvide(this.createPIN, this.network);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create:
            (_) => AuthBloc(
              authRepository: AuthRepositoryImpl(
                authRemoteDatasource: AuthRemoteDatasource(
                  dio: ApiClient().getDio(),
                ),
              ),
            ),
        child: LoginpageWithAC(createPIN, network),
      ),
    );
  }
}
