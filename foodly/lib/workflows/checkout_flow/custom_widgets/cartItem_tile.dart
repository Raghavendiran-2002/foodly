import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/cart.dart';
import '../../../models/cartFoodItem.dart';
import '../../home_flow/screens/search_screen.dart';

class CartItemTile extends StatefulWidget {
  final CartFoodItem cartFoodItem;

  CartItemTile({required this.cartFoodItem});
  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile>
    with TickerProviderStateMixin {
  late AnimationController _searchResultsAnimController;
  late Animation<Offset> _searchResultsOffset;

  @override
  void initState() {
    super.initState();
    _searchResultsAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    final searchResultsCurve = CurvedAnimation(
        curve: Curves.decelerate, parent: _searchResultsAnimController);

    _searchResultsOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(searchResultsCurve);
    _searchResultsAnimController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _searchResultsAnimController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _searchResultsAnimController,
      child: SlideTransition(
        position: _searchResultsOffset,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 20, 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                offset: Offset(2, 2),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/forkPH.png",
                        fit: BoxFit.contain,
                        height: 75,
                        width: 75,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cartFoodItem.foodName,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Consumer<Cart>(
                        builder: (context, cart, child) => CustomNeuIconButton(
                          icon: Icon(
                            cart.getItemQuantity(widget.cartFoodItem.foodID) ==
                                    1
                                ? FontAwesomeIcons.trashCan
                                : FontAwesomeIcons.minus,
                            size: 15,
                          ),
                          onTap: () {
                            Provider.of<Cart>(context, listen: false)
                                .decrementItem(widget.cartFoodItem.foodID);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Consumer<Cart>(
                        builder: (context, cart, child) => AnimatedFlipCounter(
                          value:
                              cart.getItemQuantity(widget.cartFoodItem.foodID),
                          textStyle: TextStyle(
                            color: cart.getItemQuantity(
                                        widget.cartFoodItem.foodID) !=
                                    0
                                ? Colors.green
                                : Colors.black,
                            fontWeight: cart.getItemQuantity(
                                        widget.cartFoodItem.foodID) !=
                                    0
                                ? FontWeight.bold
                                : FontWeight.w400,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      CustomNeuIconButton(
                        icon: Icon(
                          FontAwesomeIcons.plus,
                          size: 15,
                        ),
                        onTap: () {
                          Provider.of<Cart>(context, listen: false)
                              .incrementItem(widget.cartFoodItem.foodID);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Consumer<Cart>(
                builder: (context, cart, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Rate: \u20B9${widget.cartFoodItem.price}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "x",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Qty: ${cart.getItemQuantity(
                        widget.cartFoodItem.foodID,
                      )}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Price: \u20B9${cart.getItemQuantity(
                            widget.cartFoodItem.foodID,
                          ) * widget.cartFoodItem.price}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
