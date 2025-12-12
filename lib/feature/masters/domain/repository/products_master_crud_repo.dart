import 'package:newsee/AppData/DBConstants/table_keys_productmaster.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/simplecursor_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

class ProductMasterCrudRepo extends SimpleCrudRepo<ProductMaster>
    with SimplecursorCrudRepo<ProductMaster> {
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
  Future<int> deleteAll() {
    return _db.transaction((txn) async {
      return await txn.delete(TableKeysProductMaster.tableName);
    });
  }

  @override
  Future<int> update(ProductMaster o) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<ProductMaster>> getByColumnName({
    required String columnName,
    required String columnValue,
  }) async {
    final data = await _db.query(
      TableKeysProductMaster.tableName,
      where: '$columnName=?',
      whereArgs: [columnValue],
    );
    return List.generate(
      data.length,
      (index) => ProductMaster.fromJson(data[index]),
    );
  }

  @override
  Future<List<ProductMaster>> getByColumnNames({
    required List<String> columnNames,
    required List<String> columnValues,
  }) async {
    final query = queryBuilder(columnNames);
    final data = await _db.query(
      TableKeysProductMaster.tableName,
      where: query,
      whereArgs: columnValues,
    );
    return List.generate(
      data.length,
      (index) => ProductMaster.fromJson(data[index]),
    );
  }

  @override
  Future<List<ProductMaster>> getById({required int id}) async {
    final data = await _db.query(
      TableKeysProductMaster.tableName,
      where: "id=?",
      whereArgs: [id],
    );
    return List.generate(
      data.length,
      (index) => ProductMaster.fromJson(data[index]),
    );
  }
}
