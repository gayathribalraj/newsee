import 'package:newsee/AppData/DBConstants/dbconstants.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/simplecursor_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

class LovCrudRepo extends SimpleCrudRepo<Lov> with SimplecursorCrudRepo<Lov> {
  final Database _db;

  LovCrudRepo(this._db);

  @override
  Future<int> save(Lov o) async {
    return _db.transaction((txn) async {
      return await txn.insert(
        TableKeysLov.tableName,
        o.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> delete(Lov o) {
    throw UnimplementedError();
  }

  @override
  Future<int> deleteAll() {
    return _db.transaction((txn) async {
      return await txn.delete(TableKeysLov.tableName);
    });
  }

  @override
  Future<int> update(Lov o) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<List<Lov>> getAll() async {
    final List<Map<String, dynamic>> data = await _db.query(
      TableKeysLov.tableName,
      orderBy: "id DESC",
    );
    return List.generate(data.length, (index) => Lov.fromJson(data[index]));
  }

  @override
  Future<List<Lov>> getByColumnName({
    required String columnName,
    required String columnValue,
  }) async {
    final data = await _db.query(
      TableKeysLov.tableName,
      where: '$columnName=?',
      whereArgs: [columnValue],
    );
    return List.generate(data.length, (index) => Lov.fromJson(data[index]));
  }

  @override
  Future<List<Lov>> getByColumnNames({
    required List<String> columnNames,
    required List<String> columnValues,
  }) async {
    final query = queryBuilder(columnNames);
    final data = await _db.query(
      TableKeysLov.tableName,
      where: query,
      whereArgs: columnValues,
    );
    return List.generate(data.length, (index) => Lov.fromJson(data[index]));
  }

  @override
  Future<List<Lov>> getById({required int id}) async {
    final data = await _db.query(
      TableKeysLov.tableName,
      where: "id=?",
      whereArgs: [id],
    );
    return List.generate(data.length, (index) => Lov.fromJson(data[index]));
  }
}
