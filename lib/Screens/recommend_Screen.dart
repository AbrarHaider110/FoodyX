import 'package:FoodyX/Screens/detailScreen.dart';
import 'package:flutter/material.dart';

class RecommendScreen extends StatelessWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayItems = [
      {
        'image': "assets/R1.png",
        'price': "\$15",
        'title': "Chocolate and Fresh Fruit Crepes",
        'subtitle': "Fresh Chocolate Crepes",
        'rating': "5.0",
        'id': "crepes_001", // Added product ID
      },
      {
        'image': "assets/R2.png",
        'price': "\$12",
        'title': "Bean and Vegetable Burger",
        'subtitle': "Vegetable burger Mixed with bean",
        'rating': "4.8",
        'id': "burger_002", // Added product ID
      },
      {
        'image': "assets/R3.png",
        'price': "\$15",
        'title': "Creamy Milkshake",
        'subtitle': "Milkshake flavours with Chocolate",
        'rating': "4.9",
        'id': "milkshake_003", // Added product ID
      },
      {
        'image': "assets/R4.png",
        'price': "\$10",
        'title': "Chicken Rice",
        'subtitle': "Rice with toppins of Chicken",
        'rating': "5.0",
        'id': "chicken_rice_004", // Added product ID
      },
      {
        'image': "assets/R5.png",
        'price': "\$11",
        'title': "Beaf Rice",
        'subtitle': "Rice with chicken and Beaf",
        'rating': "5.0",
        'id': "beef_rice_005", // Added product ID
      },
      {
        'image': "assets/6.png",
        'price': "\$16",
        'title': "Mushroom Risotto",
        'subtitle': "Creamy Mushroom Risotto, cooked to perfection",
        'rating': "4.9",
        'id': "risotto_006", // Added product ID
      },
      {
        'image': "assets/7.png",
        'price': "\$18",
        'title': "Macarons",
        'subtitle': "Delicate Vanilla and Chocolate macarons",
        'rating': "5.0",
        'id': "macarons_007", // Added product ID
      },
      {
        'image': "assets/8.png",
        'price': "\$20",
        'title': "Chocolate Brownie",
        'subtitle': "Premium cocoa, melted chocolate, and a hint of vanilla",
        'rating': "4.0",
        'id': "brownie_008", // Added product ID
      },
      {
        'image': "assets/9.png",
        'price': "\$20",
        'title': "Mojito",
        'subtitle': "Made with white rum, fresh mint leaves, lime juice",
        'rating': "4.7",
        'id': "mojito_009", // Added product ID
      },
      {
        'image': "assets/10.png",
        'price': "\$20",
        'title': "Iced Coffee",
        'subtitle': "Espresso, chilled milk, and a touch of sweetness",
        'rating': "4.9",
        'id': "coffee_010", // Added product ID
      },
    ];

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                  itemCount: displayItems.length,
                  itemBuilder: (context, index) {
                    final item = displayItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailScreen(
                                  image: item['image'],
                                  price: item['price'],
                                  title: item['title'],
                                  subtitle: item['subtitle'],
                                  rating: item['rating'],
                                  productId: item['id'], // Added productId
                                ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildContainer(
                          item['image'],
                          item['price'],
                          item['title'],
                          item['subtitle'],
                          item['rating'],
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
