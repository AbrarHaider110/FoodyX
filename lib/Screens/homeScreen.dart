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
            color: Color(0xFFE95322),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  color: Color(0xFFE95322),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.shopping_bag),
                    title: Text(
                      'My Orders',
                      style: TextStyle(color: Colors.white),
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.person),
                    title: Text(
                      'My Profile',
                      style: TextStyle(color: Colors.white),
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.location_on),
                    title: Text(
                      'Delivery Address',
                      style: TextStyle(color: Colors.white),
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.credit_card),
                    title: Text(
                      'Payment Methods',
                      style: TextStyle(color: Colors.white),
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.phone_in_talk),
                    title: Text(
                      'Contact Us',
                      style: TextStyle(color: Colors.white),
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.question_answer),
                    title: Text(
                      'Help and FAQs',
                      style: TextStyle(color: Colors.white),
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.settings),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: Colors.white),
                    ),
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: _buildIconContainer(Icons.logout_outlined),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {},
                  ),
                ),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: _buildIconContainer(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color(0xFFF5CB58),
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          size: 20,
                          color: Color(0xFFE95322),
                        ),
                        onPressed: () {},
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
                  style: TextStyle(color: Color(0xFFE95322)),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.26,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.26,
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      color: Color(0xFFE95322),
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
            child: Image.asset("assets/dx5.png"),
          ),
          Positioned(
            top: screenHeight * 0.73,
            left: screenWidth * 0.11,
            right: screenWidth * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Experience our", style: TextStyle(color: Colors.white)),
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
          // Positioned(
          //   top: screenHeight * 0.90,
          //   left: screenWidth * 0.06,
          //   right: screenWidth * 0.06,
          //   child: Text(
          //     "Recommend",
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   ),
          // ),
          //     Positioned(
          //       top: screenHeight * 0.95,
          //       left: screenWidth * 0.06,
          //       right: screenWidth * 0.06,
          //       bottom: 10,
          //       child: SizedBox(
          //         height: 300, // Increased height to fit grid items
          //         child: GridView.builder(
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //             crossAxisCount: 2, // Adjust the number of columns as needed
          //             crossAxisSpacing: 10,
          //             mainAxisSpacing: 10,
          //             childAspectRatio: 1.5, // Adjust for better responsiveness
          //           ),
          //           itemCount: 8,
          //           itemBuilder: (context, index) {
          //             return Container(
          //               width: screenWidth * 0.4, // Responsive width
          //               height: 100,
          //               color: Color(0xffbf0d0d),
          //             );
          //           },
          //         ),
          //       ),
          //     ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Color(0xFFE95322)),
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
              color: Color(0xFFE95322),
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
