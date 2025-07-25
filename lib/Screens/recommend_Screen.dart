import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/detailScreen.dart';

class RecommendScreen extends StatelessWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<String>> displayImages = [
      [
        "assets/R1.png",
        "\$15",
        "Chocolate and Fresh Fruit Crepes",
        "Fresh Chocolate Crepes",
        "5.0",
      ],
      [
        "assets/R2.png",
        "\$12",
        "Bean and Vegetable Burger",
        "Vegetable burger Mixed with bean",
        "4.8",
      ],
      [
        "assets/R3.png",
        "\$15",
        "Creamy Milkshake",
        "Milkshake flavours with Chocolate",
        "4.9",
      ],
      [
        "assets/R4.png",
        "\$10",
        "Chicken Rice",
        "Rice with toppins of Chicken",
        "5.0",
      ],
      [
        "assets/R5.png",
        "\$11",
        "Beaf Rice",
        "Rice with chicken and Beaf ",
        "5.0",
      ],
      [
        "assets/6.png",
        "\$16",
        "Mushroom Risotto",
        "Creamy Mushroom Risotto, cooked to perfection",
        "4.9",
      ],
      [
        "assets/7.png",
        "\$18",
        "Macarons",
        "Delicate Vanilla and Chocolate macarons",
        "5.0",
      ],
      [
        "assets/8.png",
        "\$20",
        "Chocolate Brownie",
        "Premium cocoa, melted chocolate, and a hint of vanilla",
        "4.0",
      ],
      [
        "assets/9.png",
        "\$20",
        "Mojito",
        "Made with white rum, fresh mint leaves, lime juice",
        "4.7",
      ],
      [
        "assets/10.png",
        "\$20",
        "Iced Coffee",
        "Espresso, chilled milk, and a touch of sweetness",
        "4.9",
      ],
    ];

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF00D09E),
            width: screenWidth,
            height: screenHeight,
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Recommendation",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.13,
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
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: displayImages.length,
                  itemBuilder: (context, index) {
                    final item = displayImages[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailScreen(
                                  image: item[0],
                                  price: item[1],
                                  title: item[2],
                                  subtitle: item[3],
                                  rating: item[4],
                                ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildContainer(
                          item[0],
                          item[1],
                          item[2],
                          item[3],
                          item[4],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(
    String imagePath,
    String price,
    String title,
    String subtitle,
    String rating,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF00D09E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xFF00D09E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFFFFD700)),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF00D09E),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
