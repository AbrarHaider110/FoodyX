import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/thirdscreen.dart';

class secondScreen extends StatelessWidget {
  const secondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/ss.png", fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenSize.height * 0.4,
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
                    SizedBox(
                      height: screenSize.height * 0.03,
                    ), // 3% of screen height
                    Image.asset(
                      "assets/cardIcon.png",
                      height: screenSize.height * 0.08, // 8% of screen height
                    ),
                    SizedBox(height: screenSize.height * 0.015),
                    Text(
                      "Easy Payment",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.06, // 6% of screen width
                        color: const Color(0xFFE95322),
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
                            builder: (context) => const thirdScreen(),
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
                          "Next",
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
