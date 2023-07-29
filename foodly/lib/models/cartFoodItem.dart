class CartFoodItem {
  final String foodID;
  final String foodName;
  final String? imageURL;
  final num price;
  final String vendorID;
  final String kitchenID;
  int quantity;
  CartFoodItem({
    required this.foodID,
    required this.vendorID,
    required this.quantity,
    required this.price,
    required this.foodName,
    required this.imageURL,
    required this.kitchenID,
  });
  Map<String, dynamic> serializeToMap() {
    return {
      "foodID": this.foodID,
      "foodName": this.foodName,
      "imageURL": this.imageURL,
      "price": this.price,
      "vendorID": this.vendorID,
      "quantity": this.quantity,
      "kitchenID": this.kitchenID,
    };
  }
}
