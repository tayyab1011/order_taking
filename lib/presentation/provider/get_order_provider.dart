import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/get_order_model.dart';
import 'package:http/http.dart' as http;

class GetOrderProvider extends ChangeNotifier {
  bool _isLoading = false;
  GetOrderModel _getOrderModel = GetOrderModel();

  double _grossAmount = 0.0;
  double _serviceCharges = 0.0;
  double _tax = 0.0;

  bool get isLoading => _isLoading;
  GetOrderModel get getOrderModel => _getOrderModel;
  double get grossAmount => _grossAmount;
  double get serviceCharges => _serviceCharges;
  double get tax => _tax;

  Future<GetOrderModel> getOrder(String? tableName, String? branchId) async {
    await GlobalVariable.loadIpAddress();
    _isLoading = true;
    notifyListeners();
    
    try {
      final url =
          "${GlobalVariable.baseUrl}${GlobalVariable.getOrder}?Tablename=$tableName&BranchId=$branchId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _getOrderModel = GetOrderModel.fromJson(data);

        // Call function to calculate charges
        _calculateCharges();

        print("Successfully fetched order: ${response.statusCode}");
        print("Order Data: ${response.body}");

        notifyListeners();
        return _getOrderModel;
      } else {
        print("Failed to fetch order: ${response.statusCode}");
        return GetOrderModel();
      }
    } catch (e) {
      print("Error fetching order: $e");
      return GetOrderModel();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateCharges() {
    double totalAmount = 0.0;

    if (_getOrderModel.bodyList != null) {
      for (var item in _getOrderModel.bodyList!) {
        if (item.quantity != null && item.rate != null) {
          totalAmount += item.quantity! * item.rate!;
        }
      }
    }

    _grossAmount = totalAmount;
    _serviceCharges = _grossAmount * 0.0;
    _tax = _grossAmount * 0.16;


    notifyListeners();
  }
}
