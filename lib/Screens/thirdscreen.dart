import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/loginScreen.dart';

class thirdScreen extends StatelessWidget {
  const thirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/ts.png", fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenSize.height * 0.4, // 40% of screen height
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05, // 5% of screen width
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.03),
                    Image.asset(
                      "assets/deliverBoyIcon.png",
                      height: screenSize.height * 0.08,
                    ),
                    SizedBox(height: screenSize.height * 0.015),
                    Text(
                      "Fast Delivery",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.06,
                        color: const Color(0xFFE95322),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.015,
                      ),
                      child: Text(
                        "Quick, reliable, and hassle-free delivery at your doorstep.",
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
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE95322),
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
                          "Get Started",
                          style: TextStyle(
                            fontSize:
                                screenSize.width *
                                0.045, // 4.5% of screen width
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
