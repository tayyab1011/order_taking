import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_tracking/data/global/global_variable.dart';

class TransferProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _responseMessage = '';

  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  Future<void> transferOrderToDineIn({
     String? orderId,
     String? orderDate,
     String? branchId,
     String? orderMode,
     String? tableNo,
     String? covers,
     String? transferBy,
  }) async {
    
    GlobalVariable.loadIpAddress;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("${GlobalVariable.baseUrl}${GlobalVariable.transferOrder}"
          "orderid=$orderId&orderdate=$orderDate&branchid=$branchId&"
          "ordermode=$orderMode&tableno=$tableNo&covers=$covers&TransferBy=$transferBy"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _responseMessage = data["Message"] ?? "No response message";
        print('Hogya');
      } else {
        _responseMessage = "Failed: ${response.statusCode}";
        print('War gya');
      }
    } catch (e) {
      _responseMessage = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
