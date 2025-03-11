import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SwitchToScreen extends StatefulWidget {
  final Widget targetScreen;
  const SwitchToScreen({super.key, required this.targetScreen});

  @override
  State<SwitchToScreen> createState() => _SwitchToScreenState();
}

class _SwitchToScreenState extends State<SwitchToScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToTarget();
  }

  void _navigateToTarget() async {
    await Future.delayed(const Duration(seconds: 2)); // Wait before navigating
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => widget.targetScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/loading.json', // Path to your Lottie animation
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
