import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/menu_model.dart';
import 'package:http/http.dart' as http;

class MenuProvider extends ChangeNotifier {
  bool _isloading = false;
  List<MenuModel> _menu = [];
  bool get isLoading => _isloading;
   List<MenuModel> get menuList => _menu;

  List<String> get menuName => _menu.map((menu) => menu.name ?? '').toList();
  List<double?> get menuRate => _menu.map((name) => name.rate).toList();
  List<int?> get catId => _menu.map((id) => id.cid).toList();

  Future<void> getMenu() async {
    await GlobalVariable.loadIpAddress();
    _isloading = true;
    notifyListeners();
    try {
      final response = await http.get(
          Uri.parse("${GlobalVariable.baseUrl}api/Host/GetMenus?Menuname=''"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _menu = data.map((menu) => MenuModel.fromJson(menu)).toList();
      } else {
        _menu = [];
      }
    } catch (e) {
      _menu = [];
      print("Error fetching menu: $e"); // Debugging log
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
