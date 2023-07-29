import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodly/constants/hero_tags.dart';
import 'package:foodly/workflows/home_flow/screens/allCategories_screen.dart';
import 'package:foodly/workflows/home_flow/screens/categoryFoods_screen.dart';
import 'package:foodly/workflows/home_flow/screens/search_screen.dart';

import '../../../models/category.dart';
import '../../login_flow/services/phoneNumber_helper.dart';

class HomeScreen extends StatefulWidget {
  final String phoneNumber;

  HomeScreen({required this.phoneNumber});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> addItems() async {
    List itemList = [
      ["Vanilla Milk Shake", 50.0],
      ["Strawberry Milk Shake", 50],
      ["Pineapple Milk Shake", 50],
      ["Mango Milk Shake", 50],
      ["Chocolate Milk Shake", 55],
      ["Pista Milk Shake", 55],
      ["Black Current Milk Shake", 55],
      ["Butter Scotch Milk Shake", 55],
      ["Oreo Milk Shake", 65],
      ["Banana Milk Shake", 70],
      ["Cold Coffee", 65.0]
    ];

    for (int i = 0; i < itemList.length; i++) {
      var docRef = FirebaseFirestore.instance.collection("foodItems").doc();
      await docRef.set(
        {
          "categoryID": "oxoXJGY07Fost4FKlMbj",
          "kitchenID": "UuX6MIQIMe3shigJ0fbD",
          "foodID": docRef.id,
          "foodName": itemList[i][0],
          "price": itemList[i][1],
          "categoryName": "Milkshakes",
          "searchTerms": generateSearchTerms(itemList[i][0]),
          "imageURL": null,
          "rating": null,
        },
      );
    }
  }

  List<String> generateSearchTerms(String name) {
    List<String> searchTerms = [];
    var wordList = name.split(" ");
    for (String word in wordList) {
      List<String> wordTerms = [];

      ///enforce food name cant be less than 3 chars in firebase or addFoodFunction in admin prolly
      for (int i = 3; i < word.length + 1; i++) {
        wordTerms.add(word.substring(0, i).toLowerCase());
      }
      searchTerms.addAll(wordTerms);
    }
    return searchTerms;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       Color(0xFF314755),
      //       Color(0xFF26A0DA),
      //     ],
      //     begin: Alignment.bottomCenter,
      //     end: Alignment.topCenter,
      //   ),
      // ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF3C5667),
                        Color(0xFF26A0DA),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  //top padding : notch height + 15
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).padding.top + 15, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "👋   Hi, ${() {
                              return PhoneNumberHelper()
                                  .formatPhoneNumberWithCountryCode(
                                      widget.phoneNumber, 2,
                                      spaceBetweenNum: false);
                            }()}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_outlined,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.purple,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New Krishna Canteen",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "SASTRA University",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 150,
                  child: Hero(
                    tag: HeroTags.search,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFAFAFA),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SearchScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Search for a food...",
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AllCategoriesScreen(
                          vendorID: "nIhlGIiIiV2YEgwuCaBK3LbYB",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "See more",
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CategoriesListView(),
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "For you",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 3),
              pauseAutoPlayOnTouch: true,
            ),
            items: [1, 2, 3, 4, 5, 6].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                    ),
                    child: Center(
                      child: Text(
                        'Offer $i',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class CategoriesListView extends StatefulWidget {
  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  late bool _isLoading;
  List<FoodCategory> categoryList = [];
  Future<void> fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    //todo: maybe move categories and carousel loading to main_nav itself to prevent reloading on PageNav
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("foodCategories")
        .where("vendorID", isEqualTo: "nIhlGIiIiV2YEgwuCaBK3LbYB")
        .limit(8)
        .get();
    categoryList = FoodCategory.deserializeDocuments(querySnapshot.docs);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: _isLoading
          ? SpinKitWave(
              color: Colors.blue,
              size: 25.0,
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (BuildContext context, int index) =>
                  CategoryListViewWidget(
                categoryName: categoryList[index].categoryName,
                backgroundColor: categoryList[index].iconBackgroundColor,
                categoryIconURL: categoryList[index].iconStorageURL,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CategoryFoodsScreen(
                        category: categoryList[index],
                      ),
                    ),
                  );
                },
              ),
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                width: 20,
              ),
            ),
    );
  }
}

class CategoryListViewWidget extends StatelessWidget {
  final String categoryName;
  final Color? backgroundColor;
  final String? categoryIconURL;
  final VoidCallback? onTap;
  CategoryListViewWidget(
      {required this.categoryName,
      required this.backgroundColor,
      required this.categoryIconURL,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap, //if not specified, null
      child: Column(
        children: [
          CategoryIconWithBackground(
            backgroundColor: backgroundColor,
            categoryIconURL: categoryIconURL,
            imageSize: 60,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            categoryName,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIconWithBackground extends StatelessWidget {
  const CategoryIconWithBackground({
    Key? key,
    required this.backgroundColor,
    required this.categoryIconURL,
    this.imageSize = 60,
  }) : super(key: key);

  final Color? backgroundColor;
  final String? categoryIconURL;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor ?? Color(0xFFFDEAD3),
        //color when backgroundColor is specified, but null
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: categoryIconURL == null
          ? Image.asset(
              "assets/images/forkPH.png",
              height: imageSize,
              width: imageSize,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 60,
                width: 60,
                imageUrl: categoryIconURL!,
                placeholder: (context, url) => Image.asset(
                  "assets/images/forkPH.png",
                  height: 60,
                  width: 60,
                ),
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                },
              ),
            ),
    );
  }
}
