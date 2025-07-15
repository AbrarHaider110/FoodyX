import 'package:flutter/material.dart';
import 'package:food_delivery/Screens/HelpScreen.dart';
import 'package:food_delivery/Screens/bestSellerScreen.dart';
import 'package:food_delivery/Screens/homeScreen.dart';

class bottomBarScreen extends StatefulWidget {
  const bottomBarScreen({Key? key}) : super(key: key);

  @override
  _bottomBarScreenState createState() => _bottomBarScreenState();
}

class _bottomBarScreenState extends State<bottomBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    homeScreen(),
    Center(child: Text("Buffet Screen")),
    bestSellerScreen(),
    Center(child: Text("List Screen")),
    helpScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 50, // Adjust height to make it smaller
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFFE95322),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            iconSize: 25, // Reduce icon size
            selectedLabelStyle: TextStyle(fontSize: 0), // Reduce font size
            unselectedLabelStyle: TextStyle(fontSize: 0),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/BBN1.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/BBN2.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/BBN3.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/BBN4.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/BBN5.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
