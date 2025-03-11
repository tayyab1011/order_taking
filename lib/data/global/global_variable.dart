
import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariable{
  static var ipsaved ;
  
  static Future<void> saveIpAddress(String ip) async {
    final prefs = await SharedPreferences.getInstance();
   ipsaved= prefs.setString('ipAddress', ip);
    

  }
    static Future<void> loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    ipsaved = prefs.getString('ipAddress');
  }

  static String baseUrl = "http://$ipsaved/";
  static const String loginUrl = 'api/Host/Login?';
  static const String allTables = 'api/host/AllTables';
  static const String category = 'api/host/GetCategories';
  static const String menu = 'api/Host/GetMenus?';
  static const String cheifs = 'api/Host/GetChefs';
  static const String order = 'api/Host/Order';
  static const String getOrder = 'api/Host/GetTableOrder';
  static const String postOrder = 'api/Host/Order';
  static const String getConfiguration = 'api/Host/GetConfiguration';
  static const String getPendingOrders = 'api/Host/GetPendingOrders?';
  static const String transferOrder = 'api/Host/OrderTransfertoDineIn?';
}
