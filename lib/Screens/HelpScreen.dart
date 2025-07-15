import 'package:flutter/material.dart';

class helpScreen extends StatelessWidget {
  const helpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFF5CB58),
            width: screenWidth,
            height: screenHeight,
          ),
          Positioned(
            top: screenHeight * 0.06,
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
            top: screenHeight * 0.11,
            left: screenWidth * 0.27,
            right: screenWidth * 0.20,
            child: Text(
              "How Can We Help You?",
              style: TextStyle(
                color: Color(0xFFE95322),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
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
            ),
          ),
          Positioned(
            top: screenHeight * 0.2,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 135,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFDECF),
                      foregroundColor: Color(0xFFE95322),
                    ),
                    child: Text("FAQ"),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 135,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE95322),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Contact Us"),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.3,
            left: screenWidth * 0.12,
            child: Row(
              children: [
                Image.asset("assets/headphones.png"),
                SizedBox(width: 15),
                Text(
                  "Customer Service",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 70),
                Image.asset("assets/a1.png"),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.37,
            left: screenWidth * 0.12,
            child: Row(
              children: [
                Image.asset("assets/Global.png"),
                SizedBox(width: 15),
                Text(
                  "Website",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 151),
                Image.asset("assets/a1.png"),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.45,
            left: screenWidth * 0.12,
            child: Row(
              children: [
                Image.asset("assets/WhatApp.png"),
                SizedBox(width: 15),
                Text(
                  "WhatsApp",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 130),
                Image.asset("assets/a1.png"),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.53,
            left: screenWidth * 0.12,
            child: Row(
              children: [
                Image.asset("assets/Facebook.png"),
                SizedBox(width: 15),
                Text(
                  "Facebook",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 137),
                Image.asset("assets/a1.png"),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.61,
            left: screenWidth * 0.12,
            child: Row(
              children: [
                Image.asset("assets/Instagram.png"),
                SizedBox(width: 15),
                Text(
                  "Instagram",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 132),
                Image.asset("assets/a1.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
