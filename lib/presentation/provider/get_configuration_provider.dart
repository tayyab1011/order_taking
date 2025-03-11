import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/get_configuration_model.dart';
import 'package:http/http.dart' as http;

class GetConfigurationProvider extends ChangeNotifier {
  bool _isloading = false;
  GetCpnfigurationModel _getCpnfigurationModel = GetCpnfigurationModel();

  bool get isLoading => _isloading;
  GetCpnfigurationModel get getCpnfigurationModel => _getCpnfigurationModel;

  Future<GetCpnfigurationModel> getConfig() async {
  await GlobalVariable.loadIpAddress();
  _isloading = true;
  notifyListeners();
  try {
    final response = await http.get(Uri.parse(
        "${GlobalVariable.baseUrl}${GlobalVariable.getConfiguration}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _getCpnfigurationModel = GetCpnfigurationModel.fromJson(data);  // Update model
      notifyListeners();  // Notify UI of changes
      return _getCpnfigurationModel;
    } else {
      return GetCpnfigurationModel();
    }
  } catch (e) {
    return GetCpnfigurationModel();
  } finally {
    _isloading = false;
    notifyListeners();
  }
}

}
