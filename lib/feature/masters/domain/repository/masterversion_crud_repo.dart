import 'package:newsee/AppData/DBConstants/table_key_masterversion.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/simplecursor_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

class MasterversionCrudRepo extends SimpleCrudRepo<MasterVersion>
    with SimplecursorCrudRepo<MasterVersion> {
  final Database _db;

  MasterversionCrudRepo(this._db);

  @override
  Future<int> delete(MasterVersion o) {
    throw UnimplementedError();
  }

  @override
  Future<int> save(MasterVersion o) async {
    return _db.transaction((txn) async {
      return await txn.insert(
        TableKeyMasterversion.tableName,
        o.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> update(MasterVersion o) async {
    return await _db.transaction((txn) async {
      return await txn.update(
        TableKeyMasterversion.tableName,
        o.toMap(),
        where: 'mastername = ?',
        whereArgs: [o.mastername],
      );
    });
  }

  @override
  Future<List<MasterVersion>> getAll() async {
    final List<Map<String, dynamic>> data = await _db.query(
      TableKeyMasterversion.tableName,
      orderBy: "id DESC",
    );
    return List.generate(
      data.length,
      (index) => MasterVersion.fromMap(data[index]),
    );
  }

  @override
  Future<List<MasterVersion>> getByColumnName({
    required String columnName,
    required String columnValue,
  }) async {
    final data = await _db.query(
      TableKeyMasterversion.tableName,
      where: '$columnName=?',
      whereArgs: [columnValue],
    );
    return List.generate(
      data.length,
      (index) => MasterVersion.fromJson(data[index]),
    );
  }

  @override
  Future<int> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<List<MasterVersion>> getByColumnNames({
    required List<String> columnNames,
    required List<String> columnValues,
  }) {
    // TODO: implement getByColumnNames
    throw UnimplementedError();
  }

  @override
  Future<List<MasterVersion>> getById({required int id}) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
