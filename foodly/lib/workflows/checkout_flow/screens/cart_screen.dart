import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:foodly/models/cart.dart';
import 'package:foodly/models/cartFoodItem.dart';
import 'package:foodly/services/UID_tracker.dart';
import 'package:foodly/workflows/checkout_flow/services/checkout.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../custom_widgets/cartItem_tile.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void checkoutWithPlatform(PaymentPlatform paymentPlatform, num amount) {
    Checkout checkout =
        Checkout(amount: amount, paymentResultCallback: paymentResultCallback);
    bool platformSupported = checkout.pay(paymentPlatform: paymentPlatform);
    if (!platformSupported) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Platform not supported!",
        desc: paymentPlatform.toString(),
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
          )
        ],
      ).show();
    }
  }

  void paymentResultCallback(PaymentResult paymentResult, {String? paymentID}) {
    if (paymentResult == PaymentResult.SUCCESS) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Payment Successful!",
        desc: "Payment ID: $paymentID",
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Payment Failed!",
        desc: "Payment aborted by user",
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
          )
        ],
      ).show();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.blue,
        title: Text(
          "Cart",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.purple,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New Krishna Canteen",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "SASTRA University",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, widget) => ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: cart.getTotalItemsQuantity(),
                itemBuilder: (context, index) => CartItemTile(
                  cartFoodItem: cart.getCartItemByIndex(index),
                ),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 20,
                ),
              ),
            ),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    offset: Offset(0, -10),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              height: 135,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total   ",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "\u20B9",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              cart.getTotalPrice().toString(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Material(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Container(
                                            width: 60,
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Cost Split-up",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 45),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Subtotal",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  "\u20B91282.23",
                                                  style: TextStyle(),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "CGST",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  "\u20B94.5",
                                                  style: TextStyle(),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "SGST",
                                                  style: TextStyle(),
                                                ),
                                                Text(
                                                  "\u20B94.5",
                                                  style: TextStyle(),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Convenience Fee",
                                                      style: TextStyle(),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    ElTooltip(
                                                      position:
                                                          ElTooltipPosition
                                                              .topStart,
                                                      child: Icon(
                                                        Icons.info_outline,
                                                        size: 18,
                                                        color: Colors.grey,
                                                      ),
                                                      content: Text(
                                                        "Payment processing charges and extras blaj blah blah",
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "\u20B92.2",
                                                  style: TextStyle(),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Divider(
                                              thickness: 0.5,
                                              color: Colors.grey,
                                              indent: 20,
                                              endIndent: 20,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "\u20B912824.23",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Payment status",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Failed",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    List<Map> orderItems = [];
                                    List<Map> kitchens = [];
                                    for (int i = 0;
                                        i < cart.getTotalItemsQuantity();
                                        i++) {
                                      CartFoodItem cartFoodItem =
                                          cart.getCartItemByIndex(i);
                                      orderItems.add({
                                        "foodItemID": cartFoodItem.foodID,
                                        "foodItemName": cartFoodItem.foodName,
                                        "quantity": cartFoodItem.quantity,
                                        "rate": cartFoodItem.price,
                                        "amount": cartFoodItem.price *
                                            cartFoodItem.quantity,
                                      });
                                      if (kitchens
                                          .where((element) =>
                                              element["kitchenID"] ==
                                              cartFoodItem.kitchenID)
                                          .isEmpty)
                                        kitchens.add({
                                          "kitchenID": cartFoodItem.kitchenID,
                                          "receiptPrinted": false
                                        });
                                    }
                                    var docRef = FirebaseFirestore.instance
                                        .collection("vendors")
                                        .doc(UIDTracker.vendorID)
                                        .collection("activeOrders")
                                        .doc();
                                    await docRef.set({
                                      "orderItems": orderItems,
                                      "kitchens": kitchens,
                                      "orderID": docRef.id,
                                      "userID": UIDTracker.userUID,
                                      "pendingKitchenPrints": kitchens.length,
                                      "totalAmount": cart.getTotalPrice(),
                                      "secretKey":
                                          randomAlpha(2).toUpperCase() +
                                              randomNumeric(2),
                                    });
                                    print("Success!");
                                  },
                                  child: Text(
                                    "Success",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2A1A5E),
                          // elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Checkout (${cart.getTotalQuantity().toString()} items)",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
