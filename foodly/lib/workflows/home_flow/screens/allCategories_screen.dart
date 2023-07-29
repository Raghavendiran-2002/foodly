import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodly/workflows/home_flow/screens/home_screen.dart';

import '../../../models/category.dart';

class AllCategoriesScreen extends StatefulWidget {
  final String vendorID;
  AllCategoriesScreen({required this.vendorID});
  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  List<FoodCategory> categoryList = [];
  Future<void> fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("foodCategories")
        .where("vendorID", isEqualTo: widget.vendorID)
        .get();
    categoryList = FoodCategory.deserializeDocuments(querySnapshot.docs);
    setState(() {
      _isLoading = false;
    });
  }

  late bool _isLoading;
  @override
  void initState() {
    fetchCategories();
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
            )),
        title: Text(
          "All Categories",
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
          : GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              itemCount: categoryList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 0,
                childAspectRatio: 0.8,
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) =>
                  OutlinedCategoryWidget(
                categoryName: categoryList[index].categoryName,
                iconStorageURL: categoryList[index].iconStorageURL,
              ),
            ),
    );
  }
}

class OutlinedCategoryWidget extends StatelessWidget {
  const OutlinedCategoryWidget({
    Key? key,
    required this.categoryName,
    required this.iconStorageURL,
  }) : super(key: key);

  final String categoryName;
  final String? iconStorageURL;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Center(
              child: CategoryIconWithBackground(
                imageSize: 45,
                backgroundColor: Colors.transparent,
                categoryIconURL: iconStorageURL,
              ),
            ),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
