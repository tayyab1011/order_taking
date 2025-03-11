import 'package:flutter/material.dart';
import 'package:order_tracking/core/helper/custom_toast.dart';
import 'package:http/http.dart' as http;
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionProvider extends ChangeNotifier {
  TextEditingController ipAddressController = TextEditingController();
  bool _loading = false;

  bool get loading => _loading;

  Future<void> loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedIp = prefs.getString('ipAddress');
    if (savedIp != null) {
      ipAddressController.text = savedIp;
    }
  }


  Future checkConnection(String ip, BuildContext context) async {
    String url = 'http://$ip/api/Host/CheckConnection?IP=$ip';

    _loading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        CustomToast.showToast(message: "Connection Successful");
        _loading = false;
        notifyListeners();

        await GlobalVariable.saveIpAddress(ip);
      } else {
        CustomToast.showToast(
            message: "Failed to connect. Please enter a valid IP.");

        _loading = false;
        notifyListeners();
      }
    } catch (e) {
      CustomToast.showToast(message: "Network error. Please try again.");

      _loading = false;
      notifyListeners();
    }
  }
}
