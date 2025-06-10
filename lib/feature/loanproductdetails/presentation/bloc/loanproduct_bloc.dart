/* 
@author    : karthick.d 05/06/2025
@desc      : LoanproductBloc - encapsulates business logic of loanproducts page
@param     : 
 */
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_products.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/product_schema_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_master_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part './loanproduct_event.dart';
part 'loanproduct_state.dart';

class LoanproductBloc extends Bloc<LoanproductEvent, LoanproductState> {
  LoanproductBloc() : super(LoanproductState.init()) {
    on<LoanproductInit>(onLoanProductInit);
    on<LoanProductDropdownChange>(onLoanProductDropdownChange);
  }

  Future<void> onLoanProductInit(LoanproductInit event, Emitter emit) async {
    // initiate the dataset for typeofloan
    String leadId = event.loanproductState.leadId ?? '';
    Database db = await DBConfig().database;
    if (leadId.isEmpty) {
      List<ProductSchema> productSchemaList =
          await ProductSchemaCrudRepo(db).getAll();
      print('productSchemaList from DB => ${productSchemaList.length}');
      emit(
        state.copyWith(
          productSchemeList: productSchemaList,
          mainCategoryList: [],
          subCategoryList: [],
          productmasterList: [],
        ),
      );
    }
  }

  Future<void> onLoanProductDropdownChange(
    LoanProductDropdownChange event,
    Emitter emit,
  ) async {
    Database db = await DBConfig().database;
    String productSchemeId = "";
    print("onLoanProductDropdownChange ${event.field}");
    if (event.field is ProductSchema) {
      await onChangeProductScheme(event, productSchemeId, db, emit);
    } else if (event.field is Product) {
      Product selectedProduct = event.field as Product;
      String mainCatId = selectedProduct.lsfFacParentId;
      String subCatId = selectedProduct.lsfFacId;
      print('subCatId => $subCatId');
      await onChangeProduct(event, mainCatId, subCatId, db, emit);
    }
  }

  Future<void> onChangeProductScheme(
    LoanProductDropdownChange<dynamic> event,
    String productSchemeId,
    Database db,
    Emitter<dynamic> emit,
  ) async {
    ProductSchema loanschema = event.field as ProductSchema;
    productSchemeId = loanschema.optionId;
    print(
      'LoanproductBloc::onLoanProductDropdownChange => productSchemeId : $productSchemeId',
    );
    List<Lov> listOfLov = await LovCrudRepo(db).getByColumnNames(
      columnNames: ['Header', 'optvalue'],
      columnValues: ['AgriProductType', productSchemeId],
    );
    final optCode = listOfLov.first.optCode;
    print('listOfLov.first.optCode => $optCode');

    List<Product> mainCategoryList = await ProductsCrudRepo(
      db,
    ).getByColumnName(columnName: 'lsfFacType', columnValue: optCode);
    print('mainCategoryList => $mainCategoryList');
    emit(
      state.copyWith(
        mainCategoryList: mainCategoryList,
        subCategoryList: [],
        productmasterList: [],
      ),
    );
  }

  Future<void> onChangeProduct(
    LoanProductDropdownChange<dynamic> event,
    String mainCategoryId,
    String subCategoryId,
    Database db,
    Emitter<dynamic> emit,
  ) async {
    Product product = event.field as Product;

    // if mainCategoryId is zero then maincategory is selected
    // subcategoryproducts will be fetched
    if (mainCategoryId == "0") {
      // get all subcategory list
      List<Product> subCategoryList = await ProductsCrudRepo(
        db,
      ).getByColumnName(
        columnName: 'lsfFacParentId',
        columnValue: subCategoryId,
      );
      print('subCategoryList => $subCategoryList');
      emit(
        state.copyWith(subCategoryList: subCategoryList, productmasterList: []),
      );
    } else {
      // mainCategoryId != 0 and subCategoryId
      List<String> columnNames = ['prdMainCat', 'prdSubCat'];
      List<String> columsValues = [mainCategoryId, subCategoryId];

      List<ProductMaster> productMasterList = await ProductMasterCrudRepo(
        db,
      ).getByColumnNames(columnNames: columnNames, columnValues: columsValues);
      print('productMasterList => $productMasterList');
      emit(state.copyWith(productmasterList: productMasterList));
    }
  }
}
