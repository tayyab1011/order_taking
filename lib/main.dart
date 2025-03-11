import 'package:flutter/material.dart';
import 'package:order_tracking/presentation/provider/add_parcel_to_cart.dart';
import 'package:order_tracking/presentation/provider/add_to_cart.dart';
import 'package:order_tracking/presentation/provider/connection_provider.dart';
import 'package:order_tracking/presentation/provider/get_all_tables_provide.dart';
import 'package:order_tracking/presentation/provider/get_categories_provider.dart';
import 'package:order_tracking/presentation/provider/get_cheif_provider.dart';
import 'package:order_tracking/presentation/provider/get_configuration_provider.dart';
import 'package:order_tracking/presentation/provider/get_order_provider.dart';
import 'package:order_tracking/presentation/provider/get_pending_provider.dart';
import 'package:order_tracking/presentation/provider/invoice_provider.dart';
import 'package:order_tracking/presentation/provider/login_provider.dart';
import 'package:order_tracking/presentation/provider/menu_provider.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/provider/transfer_provider.dart';
import 'package:order_tracking/presentation/screens/auth/sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestBluetoothPermission();
  runApp(const MyApp());
}

Future<void> requestBluetoothPermission() async {
  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse, // Required for Android 12+
  ].request();
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeChangerProvider()),
        ChangeNotifierProvider(create: (_) => GetAllTablesProvider()),
        ChangeNotifierProvider(create: (_) => GetCategoriesProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => GetCheifProvider()),
        ChangeNotifierProvider(create: (_) => GetConfigurationProvider()),
        ChangeNotifierProvider(create: (_) => AddToCart()),
        ChangeNotifierProvider(create: (_) => GetOrderProvider()),
        ChangeNotifierProvider(create: (_) => AddParcelToCart()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => GetPendingProvider()),
        ChangeNotifierProvider(create: (_) => TransferProvider()),
      ],
      child: Consumer<ThemeChangerProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            theme: _lightTheme(),
            darkTheme: _darkTheme(),
            themeMode: provider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const SignIn(),
          );
        },
      ),
    );
  }

  /// Light Theme
  ThemeData _lightTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white, 
      ),
      brightness: Brightness.light,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          labelMedium: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black)),
      
    );
  }

  /// Dark Theme
  ThemeData _darkTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff3C3D37),
        foregroundColor: Colors.white,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor:
            Color(0xff2F302C),
      ),
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xff3C3D37),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
      ),
     
    );
  }
}
