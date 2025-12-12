import 'package:newsee/AppData/DBConstants/table_key_cibil_reports.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_report_table_model.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/simplecursor_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

class CibilreportsCrudRepo extends SimpleCrudRepo<CibilReportTableModel>
    with SimplecursorCrudRepo<CibilReportTableModel> {
  final Database _db;
  CibilreportsCrudRepo(this._db);

  @override
  Future<int> delete(CibilReportTableModel o) {
    throw UnimplementedError();
  }

  @override
  Future<List<CibilReportTableModel>> getAll() async {
    final List<Map<String, dynamic>> data = await _db.query(
      TableKeysCibilReports.tableName,
      orderBy: 'id DESC',
    );
    print("reportdata $data");
    return List.generate(
      data.length,
      (index) => CibilReportTableModel.fromJson(data[index]),
    );
  }

  @override
  Future<int> save(CibilReportTableModel o) async {
    return _db.transaction((txn) async {
      return await txn.insert(
        TableKeysCibilReports.tableName,
        o.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> deleteAll() {
    return _db.transaction((txn) async {
      return await txn.delete(TableKeysCibilReports.tableName);
    });
  }

  @override
  Future<int> update(CibilReportTableModel o) {
    throw UnimplementedError();
  }

  @override
  Future<List<CibilReportTableModel>> getByColumnName({
    required String columnName,
    required String columnValue,
  }) async {
    final data = await _db.query(
      TableKeysCibilReports.tableName,
      where: '$columnName=?',
      whereArgs: [columnValue],
    );
    return List.generate(
      data.length,
      (index) => CibilReportTableModel.fromJson(data[index]),
    );
  }

  @override
  Future<List<CibilReportTableModel>> getByColumnNames({
    required List<String> columnNames,
    required List<String> columnValues,
  }) async {
    final query = queryBuilder(columnNames);
    final data = await _db.query(
      TableKeysCibilReports.tableName,
      where: query,
      whereArgs: columnValues,
    );
    return List.generate(
      data.length,
      (index) => CibilReportTableModel.fromJson(data[index]),
    );
  }

  @override
  Future<List<CibilReportTableModel>> getById({required int id}) {
    throw UnimplementedError();
  }
}
