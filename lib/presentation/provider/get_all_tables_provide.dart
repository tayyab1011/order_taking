import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/all_tables_model.dart';
import 'package:http/http.dart' as http;

class GetAllTablesProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<AllTablesModel> _tables = [];

  bool get isLoading => _isLoading;
  List<AllTablesModel> get allTables => _tables;
  List<String> get tableNames => _tables.map((table) => table.tableName ?? "").toList();
  List<int?> get tableId => _tables.map((table) => table.tableId).toList();

  Future<void> getTables() async {
    await GlobalVariable.loadIpAddress();
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("${GlobalVariable.baseUrl}${GlobalVariable.allTables}"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _tables = data.map((table) => AllTablesModel.fromJson(table)).toList();
      } else {
        _tables = [];
      }
    } catch (e) {
      _tables = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
