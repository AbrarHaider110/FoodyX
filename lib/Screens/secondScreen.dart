import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/thirdscreen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/ss.png", fit: BoxFit.cover),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height:
                  isPortrait
                      ? screenSize.height * 0.4
                      : screenSize.height * 0.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenSize.height * 0.03),
                      Image.asset(
                        "assets/cardIcon.png",
                        height: screenSize.height * 0.08,
                        color: const Color(0xFF00D09E),
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      Text(
                        "Easy Payment",
                        style: TextStyle(
                          fontSize: screenSize.width * 0.06,
                          color: const Color(0xFF00D09E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.015,
                        ),
                        child: Text(
                          "Fast, secure, and hassle-free transactions anytime, anywhere.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ThirdScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D09E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.08,
                            vertical: screenSize.height * 0.015,
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
