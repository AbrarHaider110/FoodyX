import 'package:FoodyX/Screens/detailScreen.dart';
import 'package:flutter/material.dart';

class BestSellerScreen extends StatefulWidget {
  const BestSellerScreen({Key? key}) : super(key: key);

  @override
  State<BestSellerScreen> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends State<BestSellerScreen> {
  // Data structure for food items
  final List<FoodItem> foodItems = [
    FoodItem(
      image: "assets/f1.png",
      icon: "assets/small-Meals.png",
      price: "\$15",
      title: "Veg Roll",
      description:
          "A delicious and crispy vegetarian roll filled with fresh veggies and sauces.",
      rating: "5.0",
      productId: "1",
    ),
    FoodItem(
      image: "assets/f2.png",
      icon: "assets/small-Desserts.png",
      price: "\$12",
      title: "Small Bruschetta",
      description: "Toasted bread topped with fresh tomatoes and basil.",
      rating: "4.0",
      productId: "2",
    ),
    FoodItem(
      image: "assets/f3.png",
      icon: "assets/small-Desserts.png",
      price: "\$15",
      title: "Grilled Skewers",
      description: "Tender skewers grilled with seasonal veggies and herbs.",
      rating: "5.0",
      productId: "3",
    ),
    FoodItem(
      image: "assets/f4.png",
      icon: "assets/small-Meals.png",
      price: "\$10",
      title: "BBQ Tacos",
      description: "Spicy barbecue chicken with creamy white sauce.",
      rating: "5.0",
      productId: "4",
    ),
    FoodItem(
      image: "assets/f5.png",
      icon: "assets/small-Desserts.png",
      price: "\$11",
      title: "Broccoli Lasagna",
      description: "Layers of pasta with broccoli, cream, and cheese.",
      rating: "5.0",
      productId: "5",
    ),
    FoodItem(
      image: "assets/f6.png",
      icon: "assets/small-Desserts.png",
      price: "\$16",
      title: "Ice Cream",
      description: "Vanilla and chocolate mix with crunchy toppings.",
      rating: "4.0",
      productId: "6",
    ),
    FoodItem(
      image: "assets/f7.png",
      icon: "assets/small-Desserts.png",
      price: "\$18",
      title: "Brownie",
      description: "Fudgy chocolate brownie with dark cocoa.",
      rating: "5.0",
      productId: "7",
    ),
    FoodItem(
      image: "assets/f8.png",
      icon: "assets/small-Desserts.png",
      price: "\$20",
      title: "Cheese Burger",
      description: "Juicy beef patty with melted cheddar and veggies.",
      rating: "4.9",
      productId: "8",
    ),
  ];

  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(foodItems.length, (_) => false);
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
                      children: List.generate(foodItems.length, (index) {
                        final item = foodItems[index];
                        return SizedBox(
                          width: (screenWidth - 36) / 2,
                          child: _buildFoodItemCard(index, item, context),
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

  Widget _buildFoodItemCard(int index, FoodItem item, BuildContext context) {
    final isExpanded = isExpandedList[index];
    final words = item.description.split(' ');
    final shortDescription =
        words.length > 4
            ? words.sublist(0, 4).join(' ') + '...'
            : item.description;

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
                          image: item.image,
                          price: item.price,
                          title: item.title,
                          subtitle: item.description,
                          rating: item.rating,
                          productId: item.productId,
                        ),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      item.image,
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
                        Image.asset(item.icon, width: 30, height: 30),
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
                        item.price,
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
                    item.title,
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
                        item.rating,
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
                    isExpanded ? item.description : shortDescription,
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

// Data model for food items
class FoodItem {
  final String image;
  final String icon;
  final String price;
  final String title;
  final String description;
  final String rating;
  final String productId;

  FoodItem({
    required this.image,
    required this.icon,
    required this.price,
    required this.title,
    required this.description,
    required this.rating,
    required this.productId,
  });
}
