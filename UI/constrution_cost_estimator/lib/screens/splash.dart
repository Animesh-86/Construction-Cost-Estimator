import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _truckController;
  late Animation<Offset> _truckOffset;
  bool _showTitle = false;
  bool _swipeTitle = false;

  @override
  void initState() {
    super.initState();

    // Truck animation setup
    _truckController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _truckOffset = Tween<Offset>(
      begin: const Offset(1.5, 0), // Off-screen right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _truckController,
      curve: Curves.easeOut,
    ));

    // Sequence
    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _showTitle = true; // Fade in title
      });
    });

    Timer(const Duration(milliseconds: 1000), () {
      _truckController.forward(); // Slide truck in
    });

    Timer(const Duration(milliseconds: 1800), () {
      setState(() {
        _swipeTitle = true; // Slide title out
      });
    });

    Timer(const Duration(milliseconds: 2600), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _truckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 105, 30),
      body: Stack(
        children: [
          Center(
            child: AnimatedSlide(
              offset: _swipeTitle ? const Offset(-2, 0) : Offset.zero,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _showTitle ? 1.0 : 0.0,
                child: Text(
                  'Construction Estimator',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _truckOffset,
              child: const Icon(
                Icons.precision_manufacturing_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
