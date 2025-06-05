import 'package:flutter/material.dart';
import 'package:newsee/AppData/DBConstants/table_keys_productmaster.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

class ProductMasterCrudRepo extends SimpleCrudRepo<ProductMaster> {
  final Database _db;

  ProductMasterCrudRepo(this._db);

  @override
  Future<int> delete(ProductMaster o) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductMaster>> getAll() async {
    final List<Map<String, dynamic>> data = await _db.query(
      TableKeysProductMaster.tableName,
      orderBy: "id DESC",
    );
    return List.generate(
      data.length,
      (index) => ProductMaster.fromJson(data[index]),
    );
  }

  @override
  Future<int> save(ProductMaster o) async {
    return _db.transaction((txn) async {
      return await txn.insert(
        TableKeysProductMaster.tableName,
        o.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> update(ProductMaster o) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
