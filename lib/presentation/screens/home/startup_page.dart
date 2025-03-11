import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/presentation/screens/auth/sign_in.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StarupViewState();
}

class _StarupViewState extends State<StartupView> {
  @override
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                "assets/images/welcome_top_shape.png",
                width: media.width,
                height: media.width * 1.335,
              ),
              SvgPicture.asset(
                "assets/images/Group 33437.svg",
                width: media.width * 0.30,
                height: media.width * 0.32,
                fit: BoxFit.fill,
              ),
            ],
          ),
          addHeight(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Order',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 30,
                      color: ConstantsColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              addWidth(5),
              Text('Taking',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
          addHeight(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
                textAlign: TextAlign.center,
                'Quickly order your favorite meals with our easy-to-use order-taking app! Browse restaurant menus, customize your dishes, and place orders.',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
          addHeight(40),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              child: CustomButton(text: "LOGIN", onPressed: () {}))
        ],
      ),
    );
  }
}
