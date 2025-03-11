import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/presentation/dialogs/ip_dialog.dart';
import 'package:order_tracking/presentation/provider/login_provider.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';
import 'package:order_tracking/presentation/widgets/custom_text_feild.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController ipAddressController = TextEditingController();
  bool _obsecureText = true;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Load the saved IP address and check if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await GlobalVariable.loadIpAddress(); // Load the saved IP address
      if (GlobalVariable.ipsaved == null || GlobalVariable.ipsaved.isEmpty) {
        _showTutorialDialog(); // Show the tutorial dialog only if IP is not saved
      }
    });
  }

  void _showTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Before Logging In",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please save the IP address by pressing the info icon (ℹ️) in the top-right corner.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "This step is required to connect to the server.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Got it!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Set status bar color to transparent
      statusBarIconBrightness: Brightness.dark, // Set status bar icon color
    ));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Consumer<ThemeChangerProvider>(
            builder: (BuildContext context, provider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    if (provider.themeMode == ThemeMode.dark) {
                      provider.setTheme(ThemeMode.light);
                    } else {
                      provider.setTheme(ThemeMode.dark);
                    }
                  },
                  child: provider.themeMode == ThemeMode.dark
                      ? const Icon(Icons.light_mode, color: Colors.white)
                      : const Icon(Icons.dark_mode, color: Colors.black),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const IpDialog();
                      });
                },
                child: const Icon(Icons.info_outline)),
          ),
        ],
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset('assets/images/Group 33437.svg'),
              addHeight(10),
              Consumer<ThemeChangerProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "Welcome back",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: provider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
              Consumer<ThemeChangerProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 28,
                        color: provider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black, // Dynamic color
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
              addHeight(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    addHeight(3),
                    CustomTextField(
                        controller: userNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter User Name';
                          }
                          return null;
                        },
                        hintText: 'Username',
                        iconcolor: ConstantsColors.textFiledIconColor,
                        iconPath: 'assets/images/profile.svg'),
                    addHeight(20),
                    Text(
                      "Password",
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    addHeight(3),
                    Consumer<ThemeChangerProvider>(
                      builder: (context, provider, child) {
                        bool isDarkMode = provider.themeMode == ThemeMode.dark;

                        return TextFormField(
                          obscureText: _obsecureText,
                          controller: passController,
                          cursorColor: isDarkMode
                              ? Colors.white70
                              : Colors.black, // Softer white in dark mode
                          decoration: InputDecoration(
                            fillColor: isDarkMode
                                ? const Color(0xff2F302C)
                                : ConstantsColors
                                    .filledColors, // Darker gray for dark mode
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: SvgPicture.asset(
                                "assets/images/lock.svg",
                                color: isDarkMode
                                    ? Colors.white70
                                    : ConstantsColors
                                        .textFiledIconColor, // Softer white in dark mode
                              ),
                            ),
                            suffixIcon: IconButton(
                              color: isDarkMode
                                  ? Colors.white70
                                  : ConstantsColors
                                      .textFiledIconColor, // Softer white in dark mode
                              onPressed: () {
                                setState(() {
                                  _obsecureText = !_obsecureText;
                                });
                              },
                              icon: _obsecureText
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white60
                                  : ConstantsColors
                                      .textcolor, // Soft white hint text
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.grey.withOpacity(
                                        0.15), // Softer white border
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? Colors.white38
                                    : Colors.grey.withOpacity(
                                        0.15), // Muted white border
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    addHeight(30),
                    Consumer<LoginProvider>(
                      builder: (context, provider, child) {
                        return provider.isloading
                            ? const Center(
                                // Add this to constrain the size
                                child: CircularProgressIndicator(),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (userNameController.text.isEmpty &&
                                      passController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Color(0xFFF65734),
                                        content: Text(
                                          'Please Enter Username and Password',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    await provider.loginUser(
                                        userNameController.text,
                                        passController.text,
                                        context);
                                  }
                                },
                                child: CustomButton(
                                  text: 'LOGIN',
                                  onPressed: () {}, // Can be left empty
                                ),
                              );
                      },
                    ),
                    addHeight(20),
                  ],
                )),
              )
            ],
          ),
        ),
      )),
    );
  }
}
