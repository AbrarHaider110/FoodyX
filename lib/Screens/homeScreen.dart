import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/bestSellerScreen.dart';
import 'package:food_delivery/Screens/my_orders.dart';
import 'package:food_delivery/Screens/recommend_Screen.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(70),
          bottomLeft: Radius.circular(70),
        ),
        child: Drawer(
          child: Container(
            color: const Color(0xFF00D09E),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "https://www.citypng.com/public/uploads/preview/png-round-blue-contact-user-profile-icon-701751694975293fcgzulxp2k.png",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Guest",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Guest@gmail.com",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(
                  Icons.shopping_bag,
                  'My Orders',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyOrdersScreen()),
                    );
                  },
                ),

                _buildDrawerItem(Icons.person, 'My Profile'),
                _buildDrawerItem(Icons.location_on, 'Delivery Address'),
                _buildDrawerItem(Icons.credit_card, 'Payment Methods'),
                _buildDrawerItem(Icons.phone_in_talk, 'Contact Us'),
                _buildDrawerItem(Icons.question_answer, 'Help and FAQs'),
                _buildDrawerItem(Icons.settings, 'Settings'),
                const SizedBox(height: 20),
                _buildDrawerItem(Icons.logout_outlined, 'Logout'),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Row(
              children: [
                _buildIconContainer(Icons.shopping_cart),
                const SizedBox(width: 8),
                Stack(
                  children: [
                    _buildIconContainer(Icons.notifications),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: _buildIconContainer(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                color: const Color(0xFF00D09E),
              ),
              Positioned(
                top: screenHeight * 0.098,
                left: screenWidth * 0.09,
                right: screenWidth * 0.45,
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: "Search",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: Icon(
                        Icons.filter_list,
                        size: 20,
                        color: Color(0xFF00D09E),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.15,
                left: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Good Morning",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Rise and Shine! It's break time",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.27,
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Best Seller",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const BestSellerScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View All >",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF00D09E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 15,
                            children: [
                              buildImageWithText(
                                "assets/dx1.png",
                                "\$103",
                                screenWidth,
                              ),
                              buildImageWithText(
                                "assets/dx2.png",
                                "\$50",
                                screenWidth,
                              ),
                              buildImageWithText(
                                "assets/dx3.png",
                                "\$12.99",
                                screenWidth,
                              ),
                              buildImageWithText(
                                "assets/dx4.png",
                                "\$8.20",
                                screenWidth,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: AssetImage("assets/dx5.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Recommend",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecommendScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View All >",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF00D09E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 180,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildRecommendItem(
                                  "assets/1.png",
                                  "\$15",
                                  "Mexican Appetizer",
                                  "5.0",
                                  screenWidth,
                                ),
                                const SizedBox(width: 10),
                                buildRecommendItem(
                                  "assets/dx3.png",
                                  "\$12.99",
                                  "Cheese Bites",
                                  "4.8",
                                  screenWidth,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildDrawerItem(
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: ListTile(
            leading: _buildIconContainer(icon),
            title: Text(title, style: const TextStyle(color: Colors.white)),
            onTap: onTap,
          ),
        ),
        const Divider(
          color: Colors.white,
          thickness: 1,
          height: 10,
          indent: 30,
          endIndent: 30,
        ),
      ],
    );
  }

  static Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Color(0xFF00D09E)),
    );
  }

  Widget buildImageWithText(
    String imagePath,
    String price,
    double screenWidth,
  ) {
    double itemWidth = (screenWidth - (10 * 3) - 40) / 4;
    return Container(
      width: itemWidth,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 90,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            child: Container(
              width: 50,
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF00D09E),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                price,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendItem(
    String imagePath,
    String price,
    String title,
    String rating,
    double screenWidth,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              width: 160,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00D09E),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Color(0xFFFFD700)),
                  const SizedBox(width: 3),
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
          ),
          Positioned(
            bottom: 30,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00D09E),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
