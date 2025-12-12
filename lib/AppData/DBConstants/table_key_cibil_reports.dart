/* 
@author   : latha  24/10/2025
@desc     : class to keep string contants for cibi reports table 


 */
import 'package:flutter/material.dart';

@immutable
class TableKeysCibilReports {
  TableKeysCibilReports._();

  static const String tableName = 'cibilreports';
  static const String _idColumn = 'id';
  static const String _userid = 'userid';
  static const String _proposalNo = 'proposalNo';
  static const String _applicantType = 'applicantType';
  static const String _reportType = 'reportType';
  static const String _filepath = 'filepath';
  static const String _cibilScore = 'cibilScore';

  static const String createTableQuery = '''
                CREATE TABLE IF NOT EXISTS ${TableKeysCibilReports.tableName}(
            ${TableKeysCibilReports._idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${TableKeysCibilReports._userid} TEXT,
            ${TableKeysCibilReports._proposalNo} TEXT,
            ${TableKeysCibilReports._applicantType} TEXT,
            ${TableKeysCibilReports._reportType} TEXT,
            ${TableKeysCibilReports._filepath} TEXT,
            ${TableKeysCibilReports._cibilScore} TEXT
                      )
     ''';

  static String get userid => _userid;
  static String get proposalNo => _proposalNo;
}
