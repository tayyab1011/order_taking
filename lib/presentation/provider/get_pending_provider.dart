import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/get_pending_order_model.dart';

class GetPendingProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<GetPendingOrders> _getPendingOrders = [];

  bool get isLoading => _isLoading;
  List<GetPendingOrders> get getPendingOrders => _getPendingOrders;

  Future<List<GetPendingOrders>> getPending(String? time, String branchId) async {
    _isLoading = true;
    notifyListeners();  // Notify UI that loading has started

    await GlobalVariable.loadIpAddress();
    
    try {
      final response = await http.get(Uri.parse(
          "${GlobalVariable.baseUrl}${GlobalVariable.getPendingOrders}dated=$time&type=Phone&BranchId=$branchId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data is List) {
          _getPendingOrders = data.map((item) => GetPendingOrders.fromJson(item)).toList();
        } else {
          _getPendingOrders = [];  // Empty list if data is not as expected
        }

        print("Successfully fetched orders: ${response.statusCode}");
      } else {
        print("Failed to fetch orders: ${response.statusCode}");
        _getPendingOrders = [];
      }
    } catch (e) {
      print("Error fetching orders: $e");
      _getPendingOrders = [];
    }

    _isLoading = false;
    notifyListeners();  // Notify UI that loading has ended

    return _getPendingOrders;
  }
}
