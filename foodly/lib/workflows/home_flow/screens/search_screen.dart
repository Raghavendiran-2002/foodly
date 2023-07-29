import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:badges/badges.dart' as b;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodly/constants/hero_tags.dart';
import 'package:foodly/models/foodItem.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/cart.dart';
import '../../checkout_flow/screens/cart_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAnimController;
  late Animation<Offset> _textAnimOffset;

  @override
  void initState() {
    super.initState();

    _textAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final textCurve =
        CurvedAnimation(curve: Curves.decelerate, parent: _textAnimController);

    _textAnimOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(textCurve);

    Timer(Duration(milliseconds: 800), () {
      _textAnimController.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textAnimController.dispose();
  }

  List<FoodItem> searchResultFoods = [];
  bool _isLoading = true;

  Future<void> fetchSearchResults(List<String> searchTerms) async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("foodItems")
        .where("searchTerms", arrayContainsAny: searchTerms)
        .get();
    searchResultFoods = FoodItem.deserializeDocuments(querySnapshot.docs);

    setState(() {
      _isLoading = false;
    });
  }

  bool _shouldLoad = false;
  String prevSearchTerm = "";
  Timer? searchOnStoppedTyping;
  void _onChangeHandler(String value) {
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel(); // clear timer
    }
    searchOnStoppedTyping = new Timer(Duration(milliseconds: 500), () {
      //to prevent onChanged call and
      // subsequent server call from keyboard onDismiss event.
      if (value.trim().toLowerCase() == prevSearchTerm) return;
      prevSearchTerm = value.trim().toLowerCase();

      searchResultFoods.clear();
      if (value.trim().length >= 3) {
        setState(() {
          _shouldLoad = true;
        });
        fetchSearchResults(value.trim().toLowerCase().split(" "));
      } else {
        setState(() {
          _shouldLoad = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag: HeroTags.search,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 20),
                      child: Material(
                        //material added to prevent momentary debug error - missing material ancestor
                        borderRadius: BorderRadius.circular(18),
                        child: TextField(
                          onChanged: _onChangeHandler,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 25,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            suffixIcon: b.Badge(
                              position: b.BadgePosition(top: -8, end: -2),
                              //using animatedFlipCounter here bugs out the textField rendering
                              badgeContent: Consumer<Cart>(
                                builder: (BuildContext context, Cart cart,
                                    Widget? child) {
                                  return Text(
                                    cart.getTotalQuantity().toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  );
                                },
                              ),
                              toAnimate: false,
                              badgeColor: Colors.green,
                              child: IconButton(
                                onPressed: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CartScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            hintText: "Search for a food...",
                            hintStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            filled: true,
                            fillColor: Color(0xFFFAFAFA),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 23),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            (_isLoading && _shouldLoad) //len>=3 and loading
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: CustomShimmerSearchResults(),
                  )
                : (searchResultFoods.length == 0 &&
                        _shouldLoad) //empty result, len>=3
                    ? Center(
                        child: Text(
                          "No results found!",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : (searchResultFoods.length == 0 &&
                            !_shouldLoad) //empty result, len<3
                        ? Center(
                            child: FadeTransition(
                              opacity: _textAnimController,
                              child: SlideTransition(
                                position: _textAnimOffset,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    "Start typing a few letters to begin searching!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              itemCount: searchResultFoods.length,
                              itemBuilder: (BuildContext context, int index) {
                                return FoodItemTile(
                                  foodItem: searchResultFoods[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 15,
                                );
                              },
                            ),
                          )
          ],
        ),
      ),
    );
  }
}

class FoodItemTile extends StatefulWidget {
  final FoodItem foodItem;

  FoodItemTile({required this.foodItem});
  @override
  State<FoodItemTile> createState() => _FoodItemTileState();
}

class _FoodItemTileState extends State<FoodItemTile>
    with TickerProviderStateMixin {
  late AnimationController _searchResultsAnimController;
  late Animation<Offset> _searchResultsOffset;

  bool favorite = false;

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
          padding: EdgeInsets.fromLTRB(0, 5, 20, 5),
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
                              widget.foodItem.foodName,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.foodItem
                                  .categoryName!, //assertion done since categoryName null is handled in model
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
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
                            cart.getItemQuantity(widget.foodItem.foodID) == 1
                                ? FontAwesomeIcons.trashCan
                                : FontAwesomeIcons.minus,
                            size: 15,
                          ),
                          onTap: () {
                            Provider.of<Cart>(context, listen: false)
                                .decrementItem(widget.foodItem.foodID);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Consumer<Cart>(
                        builder: (context, cart, child) => AnimatedFlipCounter(
                          value: cart.getItemQuantity(widget.foodItem.foodID),
                          textStyle: TextStyle(
                            color:
                                cart.getItemQuantity(widget.foodItem.foodID) !=
                                        0
                                    ? Colors.green
                                    : Colors.black,
                            fontWeight:
                                cart.getItemQuantity(widget.foodItem.foodID) !=
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
                              .incrementOrAddItem(widget.foodItem);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          favorite = !favorite;
                        });

                        //todo: implement fav system
                      },
                      icon: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        color: favorite ? Colors.pink : Colors.black,
                      ),
                    ),
                    if (widget.foodItem.rating != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 20,
                            ),
                            //NOTE: refresh consolidated ratings once a week in firebase
                            //to prevent invalidating cache everytime someone rates
                            Text(
                              widget.foodItem.rating.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      "\u20B9${widget.foodItem.price}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomNeuIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;

  CustomNeuIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              offset: Offset(1, 1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: icon,
      ),
    );
  }
}

class CustomShimmerSearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    height: 20,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
