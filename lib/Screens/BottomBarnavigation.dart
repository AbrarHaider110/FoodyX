import 'package:FoodyX/Screens/Buffet_Screen.dart';
import 'package:FoodyX/Screens/HelpScreen.dart';
import 'package:FoodyX/Screens/bestSellerScreen.dart';
import 'package:FoodyX/Screens/homeScreen.dart';
import 'package:FoodyX/Screens/profile_Screen.dart.dart';
import 'package:flutter/material.dart';

class bottomBarScreen extends StatefulWidget {
  const bottomBarScreen({Key? key}) : super(key: key);

  @override
  _bottomBarScreenState createState() => _bottomBarScreenState();
}

class _bottomBarScreenState extends State<bottomBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    BuffetScreen(),
    BestSellerScreen(),
    helpScreen(),
    ProfileScreen(),
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
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFF00D09E),
            selectedItemColor: Colors.white70,
            unselectedItemColor: Colors.white70,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            iconSize: 25,
            selectedLabelStyle: TextStyle(fontSize: 0),
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
                    "assets/BBN5.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    color: Color(0xFFF8F8F8),
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(Icons.person_2_outlined, size: 24),
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
