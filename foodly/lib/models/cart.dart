import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodly/models/cartFoodItem.dart';
import 'package:foodly/services/UID_tracker.dart';

import 'foodItem.dart';

class Cart extends ChangeNotifier {
  //*removed static so as to not save the state upon sign out / switching vendors
  List<CartFoodItem> _cartItems = [];
  int _totalQuantity = 0;

  void incrementOrAddItem(FoodItem foodItem) {
    //todo: set max quantity or something
    CartFoodItem? item = _getMatchingItem(foodItem.foodID);
    if (item == null) {
      item = CartFoodItem(
        foodID: foodItem.foodID,
        vendorID: UIDTracker.vendorID!,
        quantity: 1,
        price: foodItem.price,
        foodName: foodItem.foodName,
        imageURL: foodItem.imageURL,
        kitchenID: foodItem.kitchenID,
      );
      _cartItems.add(item);
    } else {
      item.quantity++;
    }
    _totalQuantity++;
    _updateFirestore(item);
    notifyListeners();
  }

  void incrementItem(String foodID) {
    //todo: set max quantity or something
    CartFoodItem? item = _getMatchingItem(foodID);

    item!.quantity++;

    _totalQuantity++;
    _updateFirestore(item);
    notifyListeners();
  }

  void addItem(CartFoodItem cartFoodItem) {
    if (_getMatchingItem(cartFoodItem.foodID) == null) {
      _cartItems.add(cartFoodItem);
      _totalQuantity += cartFoodItem.quantity;
      //***called from firebase. do not call update on firebase again.
    } else {
      throw Exception("Item already exists!");
    }
  }

  void decrementItem(String foodID) {
    CartFoodItem? item = _getMatchingItem(foodID);
    if (item == null) return;
    if (item.quantity == 1) {
      _cartItems.remove(item);
      item.quantity--; //i.e: 0, done to ensure cartItem gets deleted in firebase
    } else {
      item.quantity--;
    }
    _totalQuantity--;
    _updateFirestore(item);
    notifyListeners();
  }

  Future<void> _updateFirestore(CartFoodItem cartFoodItem) async {
    if (cartFoodItem.quantity == 0) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(UIDTracker.userDocID)
          .collection("cart")
          .doc(cartFoodItem.foodID)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(UIDTracker.userDocID)
          .collection("cart")
          .doc(cartFoodItem.foodID)
          .set(
            cartFoodItem.serializeToMap(),
            SetOptions(merge: true),
          );
    }
  }

  void _clear() {
    _cartItems.clear();
    _totalQuantity = 0;
  }

  CartFoodItem getCartItemByIndex(int index) {
    return _cartItems[index];
  }

  int getItemQuantity(String foodID) {
    CartFoodItem? item = _getMatchingItem(foodID);
    if (item != null) {
      return item.quantity;
    } else {
      return 0;
    }
  }

  num getTotalPrice() {
    num price = 0;

    for (CartFoodItem cartFoodItem in _cartItems) {
      price += cartFoodItem.price * cartFoodItem.quantity;
    }
    return price;
  }

  int getTotalItemsQuantity() {
    return _cartItems.length;
  }

  int getTotalQuantity() {
    return _totalQuantity;
  }

  void ingestCartDocs(List<DocumentSnapshot> docs) {
    _clear();
    for (DocumentSnapshot doc in docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      addItem(
        CartFoodItem(
          foodID: docData["foodID"],
          foodName: doc["foodName"],
          quantity: docData["quantity"],
          vendorID: UIDTracker.vendorID!,
          price: docData["price"],
          imageURL: docData["imageURL"],
          kitchenID: docData["kitchenID"],
        ),
      );
    }
  }

  //todo: add food item object in category food item object

  CartFoodItem? _getMatchingItem(String foodID) {
    //custom function since List.singleWhere didn't fit the needs and was cumbersome
    //same internal implementation though
    for (CartFoodItem cartFoodItem in _cartItems) {
      if (cartFoodItem.foodID == foodID) {
        return cartFoodItem;
      }
    }
    return null;
  }

  Future<List<DocumentSnapshot>> updateCartFromFirestore(
      {required bool updateLocalCart}) async {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(UIDTracker.userDocID)
        .collection("cart")
        .where("vendorID", isEqualTo: UIDTracker.vendorID)
        .get(
          GetOptions(source: Source.server),
        );

    if (updateLocalCart) ingestCartDocs(cartSnapshot.docs);
    return cartSnapshot.docs;
  }
}
