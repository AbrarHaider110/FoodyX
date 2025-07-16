import 'package:flutter/material.dart';

class helpScreen extends StatelessWidget {
  const helpScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF00D09E);
  static const Color lightBackground = Color(0xFFD6F5ED);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: primaryColor,
            width: screenWidth,
            height: screenHeight,
          ),
          Positioned(
            top: isLandscape ? screenHeight * 0.04 : screenHeight * 0.06,
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: const Text(
              "Help Center",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: isLandscape ? screenHeight * 0.14 : screenHeight * 0.11,
            left: screenWidth * 0.27,
            right: screenWidth * 0.20,
            child: const Text(
              "How Can We Help You?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            top: isLandscape ? screenHeight * 0.20 : screenHeight * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightBackground,
                                foregroundColor: primaryColor,
                              ),
                              child: const Text("FAQ"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Contact Us"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildHelpRow(
                      "assets/headphones.png",
                      "Customer Service",
                      primaryColor,
                    ),
                    const SizedBox(height: 16),
                    _buildHelpRow("assets/Global.png", "Website", primaryColor),
                    const SizedBox(height: 16),
                    _buildHelpRow(
                      "assets/WhatApp.png",
                      "WhatsApp",
                      primaryColor,
                    ),
                    const SizedBox(height: 16),
                    _buildHelpRow(
                      "assets/Facebook.png",
                      "Facebook",
                      primaryColor,
                    ),
                    const SizedBox(height: 16),
                    _buildHelpRow(
                      "assets/Instagram.png",
                      "Instagram",
                      primaryColor,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpRow(String icon, String label, Color iconColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(icon, color: iconColor),
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios, color: iconColor, size: 16),
      ],
    );
  }
}
