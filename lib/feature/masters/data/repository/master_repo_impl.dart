import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/masters/data/datasource/masters_remote_datasource.dart';
import 'package:newsee/feature/masters/data/repository/geography_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/lov_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/product_master_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/product_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/productschema_parser_impl.dart';
import 'package:newsee/feature/masters/data/repository/statecity_parser_impl.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/master_request.dart';
import 'package:newsee/feature/masters/domain/modal/master_response.dart';
import 'package:newsee/feature/masters/domain/modal/master_types.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/master_repo.dart';
import 'package:newsee/feature/masters/domain/repository/masterversion_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/product_schema_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_master_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/statecity_master_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

class MasterRepoImpl extends MasterRepo {
  @override
  Future<AsyncResponseHandler<Failure, MasterResponse>> downloadMaster({
    required MasterRequest request,
  }) async {
    /* initializing types required for AsyncResponseHandler Object */

    MasterTypes masterTypes = MasterTypes.lov;
    Database db = await DBConfig().database;
    MasterResponse masterResponse = MasterResponse(
      master: [],
      masterType: masterTypes,
    );
    MasterResponse partialResponse = MasterResponse(
      masterType: masterTypes,
      master: [],
      skipMaster: false,
    );
    // MasterResponse partiallResponse = MasterPartialDownload(
    //   master;
    //   masterType;
    //   bool
    // );
    AuthFailure failure = AuthFailure(message: "");

    try {
      print(
        "Globalconfig.diffListOfMaster-in master page ${Globalconfig.diffListOfMaster}",
      );
      var listofmaster = Globalconfig.diffListOfMaster;

      bool getMaster(String name) {
        var getlist = listofmaster.where((val) => val.mastername == name);
        if (getlist.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }

      bool? lovlist = getMaster("Listofvalues");
      bool? productmasterlist = getMaster("ProductMaster");
      bool? productschemalist = getMaster("ProductScheme");
      bool? statecitylist = getMaster("StateCityMaster");

      switch (request.setupTypeOfMaster) {
        case ApiConstants.master_key_lov:
          /* Lov Master fetch from API and Save in respective table */
          masterTypes = MasterTypes.lov;
          if (listofmaster.isEmpty || lovlist) {
            final response =
                Globalconfig.isOffline
                    ? await offlineDataProvider(path: AppConstants.lovResponse)
                    : await MastersRemoteDatasource(
                      dio: ApiClient().getDio(),
                    ).downloadMaster(request);

            final String versionFromResponse = response.data['version'];
            final String masterNameFromResponse = ApiConstants.master_key_lov;

            List<Lov> lovList = LovParserImpl().parseResponse(response);
            if (lovList.isNotEmpty) {
              /* Listofvalue master downloaded and saved in table */

              Iterator<Lov> it = lovList.iterator;
              LovCrudRepo lovCrudRepo = LovCrudRepo(db);
              lovCrudRepo.deleteAll();
              while (it.moveNext()) {
                lovCrudRepo.save(it.current);
              }

              List<Lov> lovs = await lovCrudRepo.getAll();
              print('lovCrudRepo.getAll() => ${lovs.length}');

              // Save the updated master version into the db
              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'success',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Success",
              );

              masterResponse = MasterResponse(
                master: lovList,
                masterType: MasterTypes.products,
              );
            } else {
              // api response success : false , process error message
              var errorMessage = response.data['errorDesc'];
              print('on Error request.data["ErrorMessage"] => $errorMessage');

              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'failure',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Failure",
              );

              failure = AuthFailure(message: errorMessage);
            }
          } else {
            partialResponse = MasterResponse(
              masterType: MasterTypes.products,
              master: [],
              skipMaster: true,
            );
          }
        case ApiConstants.master_key_products:
          masterTypes = MasterTypes.products;
          if (listofmaster.isEmpty || productmasterlist) {
            final response =
                Globalconfig.isOffline
                    ? await offlineDataProvider(
                      path: AppConstants.productResponse,
                    )
                    : await MastersRemoteDatasource(
                      dio: ApiClient().getDio(),
                    ).downloadMaster(request);

            final String versionFromResponse = response.data['version'];
            final String masterNameFromResponse =
                ApiConstants.master_key_products;

            List<Product> productsList = ProductParserImpl().parseResponse(
              response,
            );
            List<ProductMaster> productmasterList = ProductMasterParserImpl()
                .parseResponse(response);
            print("productmasterList is printing here => $productmasterList");
            if (productsList.isNotEmpty) {
              // insert products in to products table
              Iterator<Product> it = productsList.iterator;
              ProductsCrudRepo productsCrudRepo = ProductsCrudRepo(db);
              productsCrudRepo.deleteAll();
              while (it.moveNext()) {
                productsCrudRepo.save(it.current);
              }
              print('Products saved in db successfully... ');
              List<Product> p = await productsCrudRepo.getAll();
              print('productCrudRepo.getAll() => ${p.length}');
              // masterResponse = MasterResponse(
              //   master: productsList,
              //   masterType: MasterTypes.productschema,
              // );
            } else {
              var errorMessage = response.data['errorDesc'];
              print('on Error request.data["ErrorMessage"] => $errorMessage');
              failure = AuthFailure(message: errorMessage);
            }

            if (productmasterList.isNotEmpty) {
              // insert products in to products table

              Iterator<ProductMaster> it = productmasterList.iterator;
              print("fucntion passing here for product master list => $it");
              ProductMasterCrudRepo productsMasterCrudRepo =
                  ProductMasterCrudRepo(db);
              productsMasterCrudRepo.deleteAll();
              while (it.moveNext()) {
                productsMasterCrudRepo.save(it.current);
              }
              print('Products saved in db successfully... ');
              List<ProductMaster> p = await productsMasterCrudRepo.getAll();
              print('productCrudRepo.getAll() => ${p.length}');
            } else {
              var errorMessage = response.data['errorDesc'];
              print('on Error request.data["ErrorMessage"] => $errorMessage');
              failure = AuthFailure(message: errorMessage);
            }

            if (productmasterList.isNotEmpty) {
              // insert products in to products table

              Iterator<ProductMaster> it = productmasterList.iterator;
              print("fucntion passing here for product master list => $it");
              ProductMasterCrudRepo productsMasterCrudRepo =
                  ProductMasterCrudRepo(db);
              productsMasterCrudRepo.deleteAll();
              while (it.moveNext()) {
                productsMasterCrudRepo.save(it.current);
              }
              print('Products saved in db successfully... ');
              List<ProductMaster> p = await productsMasterCrudRepo.getAll();
              print('productCrudRepo.getAll() => ${p.length}');

              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'success',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Success",
              );

              masterResponse = MasterResponse(
                master: productmasterList,
                masterType: MasterTypes.productschema,
              );
            } else {
              var errorMessage = response.data['errorDesc'];
              print('on Error request.data["ErrorMessage"] => $errorMessage');

              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'failure',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Failure",
              );

              failure = AuthFailure(message: errorMessage);
            }
          } else {
            partialResponse = MasterResponse(
              masterType: MasterTypes.productschema,
              master: [],
              skipMaster: true,
            );
          }

        case ApiConstants.master_key_productschema:
          masterTypes = MasterTypes.productschema;
          if (listofmaster.isEmpty || productschemalist) {
            final response =
                Globalconfig.isOffline
                    ? await offlineDataProvider(
                      path: AppConstants.productSchemaResponse,
                    )
                    : await MastersRemoteDatasource(
                      dio: ApiClient().getDio(),
                    ).downloadMaster(request);

            List<ProductSchema> productSchemaList = ProductSchemaParserImpl()
                .parseResponse(response);

            final String versionFromResponse = response.data['version'];
            final String masterNameFromResponse =
                ApiConstants.master_key_productschema;

            if (productSchemaList.isNotEmpty) {
              Iterator<ProductSchema> it = productSchemaList.iterator;
              ProductSchemaCrudRepo productSchemaCrudRepo =
                  ProductSchemaCrudRepo(db);
              productSchemaCrudRepo.deleteAll();
              while (it.moveNext()) {
                productSchemaCrudRepo.save(it.current);
              }
              print('Products Schema saved in db successfully... ');
              List<ProductSchema> p = await productSchemaCrudRepo.getAll();

              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'success',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Success",
              );

              print('productSchemaCrudRepo.getAll() => ${p.length}');

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Failure",
              );
              masterResponse = MasterResponse(
                master: productSchemaList,
                masterType: MasterTypes.statecitymaster,
              );
            } else {
              var errorMessage = response.data['errorDesc'];
              print('on Error request.data["ErrorMessage"] => $errorMessage');

              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'failure',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Failure",
              );

              failure = AuthFailure(message: errorMessage);
            }
          } else {
            partialResponse = MasterResponse(
              masterType: MasterTypes.statecitymaster,
              master: [],
              skipMaster: true,
            );
          }

        case ApiConstants.master_key_statecity:
          masterTypes = MasterTypes.statecitymaster;
          if (listofmaster.isEmpty || statecitylist) {
            final response =
                Globalconfig.isOffline
                    ? await offlineDataProvider(
                      path: AppConstants.statecityResponse,
                    )
                    : await MastersRemoteDatasource(
                      dio: ApiClient().getDio(),
                    ).downloadMaster(request);

            final String versionFromResponse = response.data['version'];
            final String masterNameFromResponse =
                ApiConstants.master_key_statecity;

            List<GeographyMaster> statecityList = GeographyParserImpl()
                .parseResponse(response);
            print("GeographyMaster is printing here => $statecityList");
            if (statecityList.isNotEmpty) {
              Iterator<GeographyMaster> it = statecityList.iterator;
              GeographymasterCrudRepo statecityMasterCrudRepo =
                  GeographymasterCrudRepo(db);
              statecityMasterCrudRepo.deleteAll();
              while (it.moveNext()) {
                statecityMasterCrudRepo.save(it.current);
              }
              print('State city list saved in db successfully... ');
              List<GeographyMaster> p = await statecityMasterCrudRepo.getAll();

              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'success',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Success",
              );

              print('GeographyMaster.getAll() => ${p.length}');

              masterResponse = MasterResponse(
                master: statecityList,
                masterType: MasterTypes.success,
              );
            } else {
              var errorMessage = response.data['errorDesc'];
              print('on Error request.data["ErrorMessage"] => $errorMessage');
              await updateMasterVersion(
                db,
                masterNameFromResponse,
                versionFromResponse,
                'failure',
              );

              print(
                "Master Name: $masterNameFromResponse, Version: $versionFromResponse, Failure",
              );
              failure = AuthFailure(message: errorMessage);
            }
          } else {
            partialResponse = MasterResponse(
              masterType: MasterTypes.success,
              master: [],
              skipMaster: true,
            );
          }

        default:
          break;
      }

      // returning AsyncResponseHandler...

      if (masterResponse.master.isNotEmpty) {
        return AsyncResponseHandler.right(masterResponse);
      } else if (partialResponse.skipMaster == true) {
        return AsyncResponseHandler.right(partialResponse);
      } else {
        return AsyncResponseHandler.left(failure);
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("downloadMaster-impl page $error");
      return AsyncResponseHandler.left(failure);
    }
  }

  Future<void> updateMasterVersion(
    Database db,
    String masterNameFromResponse,
    String versionFromResponse,
    String isMasterDownloadSuccess,
  ) async {
    try {
      final masterVersionCrudRepo = MasterversionCrudRepo(db);

      var dblength = await masterVersionCrudRepo.getByColumnName(
        columnName: 'mastername',
        columnValue: masterNameFromResponse,
      );

      if (dblength.isEmpty) {
        await masterVersionCrudRepo.save(
          MasterVersion(
            mastername: masterNameFromResponse,
            version: versionFromResponse,
            status: isMasterDownloadSuccess,
          ),
        );
      } else {
        await masterVersionCrudRepo.update(
          MasterVersion(
            mastername: masterNameFromResponse,
            version: versionFromResponse,
            status: isMasterDownloadSuccess,
          ),
        );
      }
    } catch (e) {
      print("Error inserting masterversion : $e");
    }
  } // now lov is a List contains Map<String,dynamic>
}
