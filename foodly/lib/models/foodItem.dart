import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String foodID;
  final String foodName;
  final String categoryID;
  final String? categoryName;
  final num price;
  final String? imageURL;
  final num? rating;
  final String? description;
  final String kitchenID;

  FoodItem({
    required this.foodID,
    required this.categoryID,
    required this.foodName,
    required this.categoryName,
    required this.price,
    required this.rating,
    required this.imageURL,
    required this.description,
    required this.kitchenID,
  });

  static List<FoodItem> deserializeDocuments(List<DocumentSnapshot> docs) {
    List<FoodItem> objects = [];

    for (DocumentSnapshot doc in docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      objects.add(
        FoodItem(
          foodID: docData["foodID"],
          categoryID: docData["categoryID"],
          categoryName: docData["categoryName"] ?? "General",
          foodName: docData["foodName"],
          price: docData["price"],
          rating: docData["rating"],
          imageURL: docData["foodImageURL"],
          description: docData["description"],
          kitchenID: docData["kitchenID"],
        ),
      );
    }
    return objects;
  }
}
