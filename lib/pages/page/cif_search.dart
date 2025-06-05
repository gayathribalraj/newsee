import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/blocs/cif/data/datasource/cif_remote_datasource.dart';
import 'package:newsee/blocs/cif/data/repository/cif_repository.dart';
import 'package:newsee/blocs/cif/domain/repository/cif_repository.dart';
import 'package:newsee/blocs/cif/presentation/bloc/cif_bloc.dart';
import 'package:newsee/core/api/api_client.dart';

class CifSearchPage extends StatelessWidget {
  const CifSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cifController = TextEditingController();

    final Dio _dio = ApiClient().getDio();
final  _cifRemoteDatasource = CifRemoteDatasource(
  dio: _dio,
);
final CifRepository cifRepository = CifRepositoryImpl(
  cifRemoteDatasource: _cifRemoteDatasource,
);

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        title: const Text(
          "CIF Search",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 216, 220, 227),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => CifBloc(cifRepository: cifRepository),
          child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocConsumer<CifBloc, CifState>(
                listener: (context, state) {
                  if (state.status == CifStatus.failure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                  } else if (state.status == CifStatus.success) {
                    print("sucesssssssssssssssssssssssssssssss");
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("CIF Result"),
                            content: Text(
                              "Customer ID: sdfsdfsdf"
                              // "CIF ID: ${state.chifResponseModel?.cifId}\n"
                              // "Type: ${state.chifResponseModel?.type}",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Enter CIF ID to Search",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: cifController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "CIF ID",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final cifId = cifController.text.trim();
                            if (cifId.isNotEmpty) {
                              context.read<CifBloc>().add(
                                SearchCif(
                                  request: {
                                    "custId": "902534",
                                    "uniqueId": "3",
                                    "cifId": cifId,
                                    "type": "borrower",
                                    "token":
                                        "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3",
                                    // "deviceId":
                                    //     "U2FsdGVkX180H+UTzJxvLfDRxLNCZeZK0gzxeLDg9Azi7YqYqp0KqhJkMb7DiIns",
                                    // "userid": "4321",
                                  },
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              81,
                              147,
                              255,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              state.status == CifStatus.loading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    "Search",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        )
    );
  }
}
