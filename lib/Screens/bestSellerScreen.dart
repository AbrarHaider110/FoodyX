import 'package:flutter/material.dart';

class bestSellerScreen extends StatelessWidget {
  const bestSellerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<String>> displayImages = [
      [
        "assets/f1.png",
        "assets/small-Meals.png",
        "\$15",
        "Veg Roll",
        "Delicious veg roll",
        "5.0",
      ],
      [
        "assets/f2.png",
        "assets/small-Desserts.png",
        "\$12",
        "Chocolate Cake",
        "Tasty chocolate",
        "4.0",
      ],
      [
        "assets/f3.png",
        "assets/small-Desserts.png",
        "\$15",
        "Strawberry Tart",
        "Sweet and fresh",
        "5.0",
      ],
      [
        "assets/f4.png",
        "assets/small-Meals.png",
        "\$10",
        "Pasta",
        "Creamy white sauce",
        "5.0",
      ],
      [
        "assets/f5.png",
        "assets/small-Desserts.png",
        "\$11",
        "Muffin",
        "Soft and delicious",
        "5.0",
      ],
      [
        "assets/f6.png",
        "assets/small-Desserts.png",
        "\$16",
        "Ice Cream",
        "Vanilla with chocolate",
        "4.0",
      ],
      [
        "assets/f7.png",
        "assets/small-Desserts.png",
        "\$18",
        "Brownie",
        "Fudgy and chocolaty",
        "5.0",
      ],
      [
        "assets/f8.png",
        "assets/small-Desserts.png",
        "\$20",
        "Fruit Salad",
        "Fresh and healthy",
        "4.0",
      ],
    ];

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

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
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: const Text(
              "Best Seller",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "Discover our most popular dishes!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF00D09E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        itemCount: displayImages.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          return _buildContainer(
                            displayImages[index][0],
                            displayImages[index][1],
                            displayImages[index][2],
                            displayImages[index][3],
                            displayImages[index][4],
                            displayImages[index][5],
                          );
                        },
                      ),
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

  Widget _buildContainer(
    String imagePath,
    String iconPath,
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
                  height: 120,
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(iconPath, width: 30, height: 30),
                    const Icon(Icons.favorite, color: Color(0xFFE95322)),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                left: 100,
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
              SizedBox(
                width: 100,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xFF00D09E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFD700), size: 10),
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
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              CircleAvatar(
                backgroundColor: Color(0xFF00D09E),
                radius: 12,
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
