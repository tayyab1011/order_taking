import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/presentation/provider/connection_provider.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';
import 'package:order_tracking/presentation/widgets/custom_text_feild.dart';
import 'package:provider/provider.dart';

class IpDialog extends StatefulWidget {
  const IpDialog({super.key});

  @override
  State<IpDialog> createState() => _IpDialogState();
}

class _IpDialogState extends State<IpDialog> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ConnectionProvider>(context, listen: false)
            .loadIpAddress());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(
      builder: (context, provider, child) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'assets/images/close.png',
                      height: 20,
                    ),
                  ),
                ],
              ),
              addHeight(10),
              Consumer<ThemeChangerProvider>(
                builder: (context, provider, child) {
                  bool isDarkMode = provider.themeMode == ThemeMode.dark;

                  return Text(
                    "IP Address",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black, // Change color dynamically
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
              addHeight(8),
              CustomTextField(
                controller: provider.ipAddressController,
                hintText: 'Enter IP address',
                iconPath: 'assets/images/location.svg',
                iconcolor: ConstantsColors.textFiledIconColor,
              ),
              addHeight(25),
              Row(
                children: [
                  Expanded(
                    child: provider.loading
                        ? const Center(child: CircularProgressIndicator())
                        : GestureDetector(
                            onTap: () {
                              String ip =
                                  provider.ipAddressController.text.trim();
                              provider.checkConnection(ip, context);
                            },
                            child: CustomButton(
                              text: 'Save IP',
                              isLoading: loading,
                              onPressed: () async {},
                            ),
                          ),
                  ),
                ],
              ),
              addHeight(15),
            ],
          ),
        );
      },
    );
  }
}
