import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:order_tracking/presentation/provider/get_configuration_provider.dart';
import 'package:order_tracking/presentation/provider/get_order_provider.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:order_tracking/core/helper/custom_toast.dart';
import 'package:order_tracking/data/models/get_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class BluetoothScreen extends StatefulWidget {
  String? tableName;
  String? branchId;

  BluetoothScreen({super.key, this.branchId, this.tableName});

  @override
  // ignore: library_private_types_in_public_api
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen>
    with WidgetsBindingObserver {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _connected = false;
  GetOrderModel? _order;
  bool _isLoading = true;
  bool _permissionChecked = false;
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_permissionChecked) {
      _getBluetoothDevices();
    }
  }
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScreen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        
        Provider.of<GetConfigurationProvider>(context, listen: false)
            .getConfig();
        
      });
      
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndReconnectBluetooth();
    }
  }

  Future<void> _initializeScreen() async {
    await _requestBluetoothPermission();
    await _fetchOrderData();
    await _checkAndReconnectBluetooth();
  }

  Future<void> _requestBluetoothPermission() async {
    var status = await Permission.bluetooth.request();
    setState(() {
      _permissionChecked = true;
    });

    if (status.isGranted) {
      await Future.delayed(const Duration(milliseconds: 500));
      await _getBluetoothDevices();
    } else {
      CustomToast.showToast(message: "Bluetooth permission denied");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkAndReconnectBluetooth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool wasConnected = prefs.getBool('isBlueDeviceConnected') ?? false;
    String? deviceAddress = prefs.getString('blueDeviceIp');

    if (wasConnected && deviceAddress != null && _devices.isNotEmpty) {
      for (var device in _devices) {
        if (device.address == deviceAddress) {
          setState(() {
            _selectedDevice = device;
          });
          await _connect();
          break;
        }
      }
    }
  }

  Future<void> _getBluetoothDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();

      if (mounted) {
        setState(() {
          _devices = devices;
          _isLoading = false;
        });

        print("Fetched ${devices.length} devices");

        if (devices.isNotEmpty) {
          await _checkAndReconnectBluetooth();
        }
      }
    } catch (e) {
      print("Error getting devices: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        CustomToast.showToast(message: "Error fetching devices: $e");
      }
    }
  }

  Future<void> _fetchOrderData() async {
    final orderProvider = Provider.of<GetOrderProvider>(context, listen: false);
    await orderProvider.getOrder(widget.tableName, '2');

    if (mounted) {
      setState(() {
        _order = orderProvider.getOrderModel;
      });
    }

    print("Order fetched: $_order");
  }

  Future<void> _connect() async {
    if (_selectedDevice != null) {
      try {
        await bluetooth.connect(_selectedDevice!);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isBlueDeviceConnected', true);
        prefs.setString('blueDeviceIp', _selectedDevice!.address ?? "Unknown");

        setState(() {
          _connected = true;
        });

        print("Connected to: ${_selectedDevice!.name}");
        CustomToast.showToast(message: "Connected Successfully");
      } catch (e) {
        print("Connection error: $e");
        
      }
    }
  }

  Future<void> _disconnect() async {
    await bluetooth.disconnect();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBlueDeviceConnected', false);
    prefs.remove('blueDeviceIp');

    setState(() {
      _connected = false;
    });
    CustomToast.showToast(message: "Disconnected");
  }

  Future<void> _printInvoice() async {
    // if (!_connected) {
    //   CustomToast.showToast(message: "Printer not connected");
    //   return;
    // }
    final configProvider = Provider.of<GetConfigurationProvider>(context, listen: false).getCpnfigurationModel;

    final orderProvider = Provider.of<GetOrderProvider>(context, listen: false);

    if (_order == null) {
      CustomToast.showToast(message: "No order data available");
      return;
    }

    try {
      bluetooth.printCustom("================================", 1, 1);
      bluetooth.printCustom("    ${configProvider.companyName}      ", 1, 1);
      bluetooth.printCustom("================================", 1, 1);
      bluetooth.printCustom("${configProvider.address}", 1, 1);
      //bluetooth.printCustom("Mumtazabad Multan", 1, 1);

      bluetooth.printCustom("${configProvider.phoneNumber}", 1, 1);

      bluetooth.printCustom("Provisional Bill", 2, 1);
      bluetooth.printCustom(
          "Date: ${DateTime.now().toLocal().toString().split(' ')[0]}", 1, 0);
      bluetooth.printCustom(
          "Time: ${DateTime.now().toLocal().toString().split(' ')[1].substring(0, 8)}",
          1,
          0);

      bluetooth.printCustom("Token No: ${_order!.orderId ?? 'N/A'}", 1, 0);
      bluetooth.printCustom(
          "Serving Unit: ${_order!.waiterName ?? 'N/A'}", 1, 0);
      bluetooth.printCustom("--------------------------------", 1, 1);
      bluetooth.printCustom("Product       Qty  Rate  Amount", 1, 0);
      bluetooth.printCustom("--------------------------------", 1, 1);

      if (_order!.bodyList != null && _order!.bodyList!.isNotEmpty) {
        for (var item in _order!.bodyList!) {
          String productName = item.menuName ?? 'Item';
          String qty = item.quantity?.toString() ?? '0';
          String rate = item.rate?.toString() ?? '0';
          String amount = (item.quantity! * item.rate!).toString();

          List<String> nameLines = [];
          int maxLineLength = 14;
          for (int i = 0; i < productName.length; i += maxLineLength) {
            nameLines.add(productName.substring(
                i,
                (i + maxLineLength > productName.length)
                    ? productName.length
                    : i + maxLineLength));
          }

          bluetooth.printCustom(
              nameLines[0].padRight(14) +
                  qty.padLeft(2) +
                  rate.padLeft(7) +
                  amount.padLeft(8),
              1,
              0);

          for (int i = 1; i < nameLines.length; i++) {
            bluetooth.printCustom(nameLines[i], 1, 0);
          }
        }
      } else {
        bluetooth.printCustom("No items found", 1, 0);
      }

      bluetooth.printCustom("--------------------------------", 1, 1);

      bluetooth.printCustom(
          "Total:           ${orderProvider.grossAmount.toStringAsFixed(2)}",
          1,
          0);
      bluetooth.printCustom(
          "Service Charges: ${orderProvider.serviceCharges.toStringAsFixed(2)}",
          1,
          0);
      bluetooth.printCustom(
          "GST:        ${orderProvider.tax.toStringAsFixed(2)}", 1, 0);
      bluetooth.printCustom(
          "Net Amount:      ${(orderProvider.grossAmount + orderProvider.tax + orderProvider.serviceCharges).toStringAsFixed(2)}",
          1,
          0);
      bluetooth.printNewLine();

      bluetooth.printCustom("Thanks for your Visit", 1, 1);
      bluetooth.printCustom("www.stit.solutions/", 1, 1);

      bluetooth.paperCut();

      CustomToast.showToast(message: "Invoice printed successfully!");
    } catch (e) {
      CustomToast.showToast(message: "Print failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeChangerProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    const darkBackground = Color(0xff3C3D37);
    const darkCardColor = Color(0xff4A4B45);
    const darkPrimaryColor = Color(0xffF4A261);
    const darkSecondaryColor = Color(0xffE76F51);
    const darkTextColor = Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? darkBackground : Colors.white,
      appBar: AppBar(
        title: Text(
          "Bluetooth Printer",
          style: TextStyle(
            color: isDarkMode ? darkTextColor : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? darkBackground : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme:
            IconThemeData(color: isDarkMode ? darkTextColor : Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: isDarkMode ? darkCardColor : Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Printer Device",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: darkPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: darkSecondaryColor,
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<BluetoothDevice>(
                          isExpanded: true,
                          hint: const Row(
                            children: [
                              Icon(
                                Icons.bluetooth_searching,
                                color: darkPrimaryColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Select Printer",
                                style: TextStyle(color: darkTextColor),
                              ),
                            ],
                          ),
                          value: _selectedDevice,
                          onChanged: (device) {
                            setState(() {
                              _selectedDevice = device;
                            });
                          },
                          items: _devices.map((device) {
                            return DropdownMenuItem(
                              value: device,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.print,
                                    color: darkPrimaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    device.name ?? "Unknown Device",
                                    style:
                                        const TextStyle(color: darkTextColor),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _connected ? _disconnect : _connect,
                    icon: Icon(_connected ? Icons.link_off : Icons.link),
                    label: Text(_connected ? "Disconnect" : "Connect"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor:
                          _connected ? darkSecondaryColor : darkPrimaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: isDarkMode ? darkCardColor : Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          color: darkPrimaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Print Operations",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _printInvoice,
                      icon: const Icon(Icons.print),
                      label: const Text("Print Invoice"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        backgroundColor: darkSecondaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _connected
                          ? "Ready to print"
                          : "Connect to a printer first",
                      style: TextStyle(
                        color: _connected ? darkPrimaryColor : Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (_connected)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: darkSecondaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: darkSecondaryColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: darkPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Connected to ${_selectedDevice?.name ?? 'printer'}",
                        style: const TextStyle(color: darkTextColor),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
