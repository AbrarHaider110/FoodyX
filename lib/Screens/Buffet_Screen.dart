import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery/Provider/order_provider.dart' as upper;
import 'detailScreen.dart';

class BuffetScreen extends StatefulWidget {
  const BuffetScreen({Key? key}) : super(key: key);

  @override
  State<BuffetScreen> createState() => _BuffetScreenState();
}

class _BuffetScreenState extends State<BuffetScreen> {
  List<bool> expandedItems = [];

  final List<List<String>> displayImages = [
    [
      "assets/1.png",
      "\$15",
      "Mexican Appetizer",
      "Crispy tortilla chips generously topped with spicy salsa, melted cheese, and guacamole—perfectly seasoned for a bold Mexican bite.",
      "5.0",
    ],
    [
      "assets/2.png",
      "\$12",
      "Pork Skewer",
      "Juicy pork skewers marinated in herbs and grilled to perfection, served with tangy dipping sauce and fresh salad on the side.",
      "4.8",
    ],
    [
      "assets/3.png",
      "\$15",
      "Fresh Prawn Ceviche",
      "Delightfully zesty shrimp ceviche marinated in citrus with diced tomatoes, onions, and cilantro—served chilled for a refreshing kick.",
      "4.9",
    ],
  ];

  @override
  void initState() {
    super.initState();
    expandedItems = List.filled(displayImages.length, false);
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
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Buffet Menu",
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildItem(context, index),
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

  Widget _buildItem(BuildContext context, int index) {
    final item = displayImages[index];
    final isExpanded = expandedItems[index];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
                        image: item[0],
                        price: item[1],
                        title: item[2],
                        subtitle: item[3],
                        rating: item[4],
                      ),
                ),
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    item[0],
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
                      color: const Color(0xFF00D09E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item[1],
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item[2],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D09E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Color(0xFFFFD700)),
                    const SizedBox(width: 4),
                    Text(
                      item[4],
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
            children: [
              Expanded(
                child: Text(
                  item[3],
                  maxLines: isExpanded ? null : 1,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    expandedItems[index] = !expandedItems[index];
                  });
                },
                child: Text(
                  isExpanded ? "Show Less" : "See More",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00D09E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                final newOrder = upper.Order(
                  title: item[2],
                  imageUrl: item[0],
                  price: double.parse(item[1].replaceAll('\$', '')),
                  quantity: 1,
                );

                Provider.of<upper.OrderProvider>(
                  context,
                  listen: false,
                ).addOrder(newOrder);
              },

              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF00D09E),
                child: Icon(Icons.shopping_cart, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
