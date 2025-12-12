import 'package:newsee/AppData/DBConstants/table_key_productschema.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/simplecursor_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductSchemaCrudRepo extends SimpleCrudRepo<ProductSchema>
    with SimplecursorCrudRepo<ProductSchema> {
  final Database _db;

  ProductSchemaCrudRepo(this._db);

  @override
  Future<int> save(ProductSchema o) async {
    return _db.transaction((txn) async {
      return await txn.insert(
        TableKeysProductSchema.tableName,
        o.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> deleteAll() {
    return _db.transaction((txn) async {
      return await txn.delete(TableKeysProductSchema.tableName);
    });
  }

  @override
  Future<int> delete(ProductSchema o) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductSchema>> getAll() async {
    final List<Map<String, dynamic>> data = await _db.query(
      TableKeysProductSchema.tableName,
      orderBy: 'optionDesc COLLATE NOCASE ASC',
    );
    print("retdata $data");
    return List.generate(
      data.length,
      (index) => ProductSchema.fromJson(data[index]),
    );
  }

  @override
  Future<int> update(ProductSchema o) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductSchema>> getByColumnName({
    required String columnName,
    required String columnValue,
  }) async {
    final data = await _db.query(
      TableKeysProductSchema.tableName,
      where: '$columnName=?',
      whereArgs: [columnValue],
    );
    return List.generate(
      data.length,
      (index) => ProductSchema.fromJson(data[index]),
    );
  }

  @override
  Future<List<ProductSchema>> getByColumnNames({
    required List<String> columnNames,
    required List<String> columnValues,
  }) async {
    final query = queryBuilder(columnNames);
    final data = await _db.query(
      TableKeysProductSchema.tableName,
      where: query,
      whereArgs: columnValues,
    );
    return List.generate(
      data.length,
      (index) => ProductSchema.fromJson(data[index]),
    );
  }

  @override
  Future<List<ProductSchema>> getById({required int id}) async {
    final data = await _db.query(
      TableKeysProductSchema.tableName,
      where: "id=?",
      whereArgs: [id],
    );
    return List.generate(
      data.length,
      (index) => ProductSchema.fromJson(data[index]),
    );
  }
}
