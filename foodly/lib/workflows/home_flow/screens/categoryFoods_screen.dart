import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodly/workflows/home_flow/screens/search_screen.dart';

import '../../../models/category.dart';
import '../../../models/foodItem.dart';

class CategoryFoodsScreen extends StatefulWidget {
  final FoodCategory category;
  CategoryFoodsScreen({required this.category});

  @override
  State<CategoryFoodsScreen> createState() => _CategoryFoodsScreenState();
}

class _CategoryFoodsScreenState extends State<CategoryFoodsScreen> {
  late bool _isLoading;
  Future<void> fetchCategoryFoods() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("foodItems")
        .where("categoryID", isEqualTo: widget.category.categoryID)
        .get();
    foodItems = FoodItem.deserializeDocuments(querySnapshot.docs);

    setState(() {
      _isLoading = false;
    });
  }

  List<FoodItem> foodItems = [];

  @override
  void initState() {
    fetchCategoryFoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.category.categoryName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? SpinKitWave(
              color: Colors.blue,
              size: 25.0,
            )
          : ListView.separated(
              itemCount: foodItems.length,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              itemBuilder: (BuildContext context, int index) => FoodItemTile(
                foodItem: foodItems[index],
              ),
              separatorBuilder: (context, int index) => SizedBox(
                height: 20,
              ),
            ),
    );
  }
}

// class FoodItem {
//   final String foodID;
//   final String foodName;
//   final String categoryID;
//   final num price;
//   final String? imageURL;
//   final num? rating;
//   final String? description;
//
//   FoodItem({
//     required this.foodID,
//     required this.categoryID,
//     required this.foodName,
//     required this.price,
//     required this.rating,
//     required this.imageURL,
//     required this.description,
//   });
// }
