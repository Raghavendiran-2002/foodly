import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodCategory {
  late String categoryName;
  late Color? iconBackgroundColor;
  late String? iconStorageURL;
  late String categoryID;
  FoodCategory(
      {required String categoryName,
      required String categoryID,
      required String? iconBackgroundColorHex,
      required String? iconStorageURL}) {
    this.categoryName = categoryName;
    this.categoryID = categoryID;
    this.iconStorageURL = iconStorageURL;

    if (iconBackgroundColorHex == null) {
      this.iconBackgroundColor = null;
    } else {
      //converting hex string to int hex (base 16) needed by color, with opacity ff
      this.iconBackgroundColor = Color(
        int.parse("ff" + iconBackgroundColorHex, radix: 16),
      );
    }
  }
  static List<FoodCategory> deserializeDocuments(List<DocumentSnapshot> docs) {
    List<FoodCategory> objects = [];
    for (DocumentSnapshot doc in docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      objects.add(
        FoodCategory(
          categoryName: docData["categoryName"],
          categoryID: docData["categoryID"],
          iconBackgroundColorHex: docData["categoryIconBackgroundColorHex"],
          iconStorageURL: docData["categoryIconStorageURL"],
        ),
      );
    }
    return objects;
  }
}
