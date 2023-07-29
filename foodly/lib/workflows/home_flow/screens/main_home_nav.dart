import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodly/services/UID_tracker.dart';
import 'package:foodly/workflows/checkout_flow/screens/cart_screen.dart';
import 'package:foodly/workflows/home_flow/screens/favorites_screen.dart';
import 'package:foodly/workflows/home_flow/screens/home_screen.dart';
import 'package:foodly/workflows/home_flow/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/cart.dart';

class MainHomeNav extends StatefulWidget {
  final String phoneNumber;
  MainHomeNav({required this.phoneNumber});
  @override
  State<MainHomeNav> createState() => _MainHomeNavState();
}

class _MainHomeNavState extends State<MainHomeNav> {
  void displaySnackBar(String message,
      {Color color = Colors.red, int durationInSeconds = 4}) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: Duration(seconds: durationInSeconds),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool isLoading = true;

  late FetchState fetchState;

  Future<void> getUserDetails() async {
    setState(() {
      fetchState = FetchState.connecting;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("userUID", isEqualTo: UIDTracker.userUID)
          .get(
            GetOptions(source: Source.server),
          );
      if (querySnapshot.docs.isEmpty) {
        ///remove this case later
        ///handling isEmpty case for now, this won't ever happen
        ///in production, after onNewUserAuth cloud function
        displaySnackBar("Not Authorized  **** to fix ****");
        UIDTracker.userUID = null;
        UIDTracker.vendorID = null;
        UIDTracker.userDocID = null;
        FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (Route<dynamic> route) => false);
      } else {
        Map<String, dynamic> data =
            querySnapshot.docs[0].data() as Map<String, dynamic>;
        if (data["linkedVendors"] == null || data["linkedVendors"].isEmpty) {
          //if 1st condition is true, it doesn't check 2nd condition. So don't
          //bother with linkedVendors being null for isEmpty operator
          displaySnackBar("No Vendors  **** to fix ****");
          UIDTracker.userUID = null;
          UIDTracker.vendorID = null;
          UIDTracker.userDocID = null;
          FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, "/", (Route<dynamic> route) => false);
        } else {
          UIDTracker.vendorID = data["linkedVendors"][0]["vendorID"];
          UIDTracker.userDocID = querySnapshot.docs[0].id;
          //todo: set userDocID = userUID in onCreate
          await Provider.of<Cart>(context, listen: false)
              .updateCartFromFirestore(updateLocalCart: true);
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      displaySnackBar("Couldn't reach servers!", durationInSeconds: 4);
    }
  }

  int _navbarSelectedIndex = 0;

  void _handleIndexChanged(int pageIndex, {bool animate = true}) {
    if (pageIndex == 2) {
      // setState(() {
      //   _navbarSelectedIndex = pageIndex;
      // });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CartScreen(),
        ),
      );
    } else {
      setState(() {
        _navbarSelectedIndex = pageIndex;
        _pageController.animateToPage(pageIndex,
            duration: Duration(milliseconds: 100), curve: Curves.ease);
      });
    }
  }

  late List<Widget> _pages;
  @override
  void initState() {
    getUserDetails();
    _pageController = PageController();
    _pages = [
      HomeScreen(phoneNumber: widget.phoneNumber),
      FavoritesScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    super.initState();
  }

  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.transparent, //over scroll color
          ),
        ),
        child: isLoading
            //todo: implement shimmer loading
            ? SpinKitWave(
                color: Colors.blue,
                size: 25.0,
              )
            : PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: _pages,
                onPageChanged: (int pageIndex) {
                  setState(() {
                    _navbarSelectedIndex = pageIndex;
                  });
                }),
      ),
      extendBody: false,
      bottomNavigationBar: NavigationBar(
        // backgroundColor: Colors.red,
        //surfaceTintColor: Colors.red,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _navbarSelectedIndex,
        onDestinationSelected: _handleIndexChanged,

        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_outline,
            ),
            label: "Favorites",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            label: "Cart",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

enum FetchState { connecting, failed, successful }
