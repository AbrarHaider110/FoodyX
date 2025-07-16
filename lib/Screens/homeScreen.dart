import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/bestSellerScreen.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(70),
          bottomLeft: Radius.circular(70),
        ),
        child: Drawer(
          child: Container(
            color: Color(0xFF00D09E),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  color: Color(0xFF00D09E),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "https://www.citypng.com/public/uploads/preview/png-round-blue-contact-user-profile-icon-701751694975293fcgzulxp2k.png?v=2025032303",
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                _buildDrawerItem(Icons.shopping_bag, 'My Orders'),
                _buildDrawerItem(Icons.person, 'My Profile'),
                _buildDrawerItem(Icons.location_on, 'Delivery Address'),
                _buildDrawerItem(Icons.credit_card, 'Payment Methods'),
                _buildDrawerItem(Icons.phone_in_talk, 'Contact Us'),
                _buildDrawerItem(Icons.question_answer, 'Help and FAQs'),
                _buildDrawerItem(Icons.settings, 'Settings'),
                SizedBox(height: 20),
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
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 12),
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: _buildIconContainer(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight * 1.2,
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 1.2,
                color: Color(0xFF00D09E),
              ),
              Positioned(
                top: screenHeight * 0.098,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.45,
                      height: 35,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          suffixIcon: Icon(
                            Icons.filter_list,
                            size: 20,
                            color: Color(0xFF00D09E),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Row(
                        children: [
                          _buildIconContainer(Icons.shopping_cart),
                          SizedBox(width: 8),
                          _buildIconContainer(Icons.notifications),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.15,
                left: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.30,
                left: 20,
                right: 20,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/Bot-menu.png"),
                      SizedBox(width: 15),
                      Image.asset("assets/Bot-menu 1.png"),
                      SizedBox(width: 15),
                      Image.asset("assets/Bot-menu 2.png"),
                      SizedBox(width: 15),
                      Image.asset("assets/Bot-menu 3.png"),
                      SizedBox(width: 1),
                      Image.asset(
                        "assets/Bot-menu 4.png",
                        width: 75,
                        height: 74,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.43,
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
                            builder: (context) => const bestSellerScreen(),
                          ),
                        );
                      },
                      child: Text(
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
              ),
              Positioned(
                top: screenHeight * 0.50,
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildImageWithText("assets/dx1.png", "\$103"),
                    buildImageWithText("assets/dx2.png", "\$50.0"),
                    buildImageWithText("assets/dx3.png", "\$12.99"),
                    buildImageWithText("assets/dx4.png", "\$8.20"),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.70,
                left: screenWidth * 0.06,
                child: Container(
                  width: screenWidth * 0.85,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage("assets/dx5.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.73,
                left: screenWidth * 0.11,
                right: screenWidth * 0.20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Experience our",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "delicious new dish",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "30% OFF",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: ListTile(
            leading: _buildIconContainer(icon),
            title: Text(title, style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ),
        Divider(
          color: Colors.white,
          thickness: 1,
          height: 10,
          indent: 30,
          endIndent: 30,
        ),
      ],
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Color(0xFF00D09E)),
    );
  }

  Widget buildImageWithText(String imagePath, String price) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Image.asset(imagePath),
        Positioned(
          bottom: 10,
          right: 5,
          child: Container(
            width: 50,
            padding: EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: Color(0xFF00D09E),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              price,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
