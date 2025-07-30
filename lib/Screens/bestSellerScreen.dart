import 'package:FoodyX/Screens/detailScreen.dart';
import 'package:flutter/material.dart';

class BestSellerScreen extends StatefulWidget {
  const BestSellerScreen({Key? key}) : super(key: key);

  @override
  State<BestSellerScreen> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends State<BestSellerScreen> {
  List<List<String>> displayImages = [
    [
      "assets/f1.png",
      "assets/small-Meals.png",
      "\$15",
      "Veg Roll",
      "A delicious and crispy vegetarian roll filled with fresh veggies and sauces.",
      "5.0",
    ],
    [
      "assets/f2.png",
      "assets/small-Desserts.png",
      "\$12",
      "Small Bruschetta",
      "Toasted bread topped with fresh tomatoes and basil.",
      "4.0",
    ],
    [
      "assets/f3.png",
      "assets/small-Desserts.png",
      "\$15",
      "Grilled Skewers",
      "Tender skewers grilled with seasonal veggies and herbs.",
      "5.0",
    ],
    [
      "assets/f4.png",
      "assets/small-Meals.png",
      "\$10",
      "BBQ Tacos",
      "Spicy barbecue chicken with creamy white sauce.",
      "5.0",
    ],
    [
      "assets/f5.png",
      "assets/small-Desserts.png",
      "\$11",
      "Broccoli Lasagna",
      "Layers of pasta with broccoli, cream, and cheese.",
      "5.0",
    ],
    [
      "assets/f6.png",
      "assets/small-Desserts.png",
      "\$16",
      "Ice Cream",
      "Vanilla and chocolate mix with crunchy toppings.",
      "4.0",
    ],
    [
      "assets/f7.png",
      "assets/small-Desserts.png",
      "\$18",
      "Brownie",
      "Fudgy chocolate brownie with dark cocoa.",
      "5.0",
    ],
    [
      "assets/f8.png",
      "assets/small-Desserts.png",
      "\$20",
      "Cheese Burger",
      "Juicy beef patty with melted cheddar and veggies.",
      "4.9",
    ],
  ];

  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(displayImages.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
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
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(displayImages.length, (index) {
                        final item = displayImages[index];
                        return SizedBox(
                          width: (screenWidth - 36) / 2,
                          child: _buildCard(
                            index,
                            image: item[0],
                            icon: item[1],
                            price: item[2],
                            title: item[3],
                            subtitle: item[4],
                            rating: item[5],
                            context: context,
                          ),
                        );
                      }),
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

  Widget _buildCard(
    int index, {
    required String image,
    required String icon,
    required String price,
    required String title,
    required String subtitle,
    required String rating,
    required BuildContext context,
  }) {
    final isExpanded = isExpandedList[index];
    final words = subtitle.split(' ');
    final shortDesc =
        words.length > 4 ? words.sublist(0, 4).join(' ') + '...' : subtitle;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DetailScreen(
                          image: image,
                          price: price,
                          title: title,
                          subtitle: subtitle,
                          rating: rating,
                        ),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 140,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    right: 8,
                    top: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(icon, width: 30, height: 30),
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
                        color: const Color(0xFF00D09E),
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
            ),
            const SizedBox(height: 10),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D09E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFD700),
                        size: 10,
                      ),
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
                    isExpanded ? subtitle : shortDesc,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpandedList[index] = !isExpandedList[index];
                    });
                  },
                  child: Text(
                    isExpanded ? " See less" : " See more",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00D09E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF00D09E),
                radius: 12,
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
