import 'dart:ffi';

import 'package:ecommerce_shoes_shop/core/const.dart';
import 'package:ecommerce_shoes_shop/core/flutter_icons.dart';
import 'package:ecommerce_shoes_shop/models/shoe_model.dart';
import 'package:ecommerce_shoes_shop/widgets/app_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' as math;

class DetailPage extends StatefulWidget {
  final ShoeModel shoeModel;
  DetailPage(this.shoeModel);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  GlobalKey _key = GlobalKey();

  double _valueHeightComponent = 0;
  bool _isOffstage = true;
  double _offsetHeight = 0;
  AppBar _appBar = AppBar();

  _getSizes() {
    if (_valueHeightComponent == 0) {
      final RenderBox renderBoxRed = _key.currentContext.findRenderObject();
      final sizeRed = renderBoxRed.size;
      _valueHeightComponent = sizeRed.height;

      double heightAppBar = _appBar.preferredSize.height;
      double paddingBottom = MediaQuery.of(context).padding.bottom;
      double paddingTop = MediaQuery.of(context).padding.top;

      double total = _valueHeightComponent +
          heightAppBar +
          paddingBottom +
          paddingTop +
          100;

      if (total <= MediaQuery.of(context).size.height) {
        double _tempoffsetHeight = MediaQuery.of(context).size.height - total;

        setState(() {
          _isOffstage = false;
          _offsetHeight = _tempoffsetHeight;
        });
      } else {
        setState(() {
          _isOffstage = true;
          _offsetHeight = 0;
        });
      }
    }
  }

  _afterLayout(_) {
    _getSizes();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.shoeModel.color,
      appBar: _appBar = AppBar(
        backgroundColor: widget.shoeModel.color,
        elevation: 0,
        title: Text("Categories"),
        leading: IconButton(
          icon: Icon(FlutterIcons.left_open_1),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              ClipPath(
                key: _key,
                clipper: AppClipper(
                    cornerSize: 0, diagonalHeight: 250, roundedBottom: false),
                child: Container(
                  //Add this.
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 230, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        child: Text(
                          "${widget.shoeModel.name}",
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildRating(),
                      SizedBox(height: 24),
                      Text(
                        "DETAILS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${widget.shoeModel.desc}",
                        style: TextStyle(fontSize: 18, color: Colors.black38),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "COLOR OPTIONS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          _buildColorOption(AppColors.blueColor),
                          _buildColorOption(AppColors.greenColor),
                          _buildColorOption(AppColors.orangeColor),
                          _buildColorOption(AppColors.redColor),
                          _buildColorOption(AppColors.yellowColor),
                        ],
                      ),
                      SizedBox(height: 20),
                      Offstage(
                          offstage: _isOffstage,
                          child: Container(
                            height: _offsetHeight,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Center(
                  child: Hero(
                    tag: "hero${widget.shoeModel.imgPath}",
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          top: 30,
                        ),
                        constraints:
                            BoxConstraints(minHeight: 50, maxHeight: 170),
                        // alignment: Alignment.center,
                        child: Transform.rotate(
                          angle: -math.pi / 100,
                          child: Image(
                            width: MediaQuery.of(context).size.width * 0.75,
                            image: AssetImage(
                                "assets/${widget.shoeModel.imgPath}"),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            )
          ],
        ),
        child: BottomAppBar(
          child: _buildBottom(),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PRICE",
                style: TextStyle(
                  color: Colors.black26,
                ),
              ),
              Text(
                "\$${widget.shoeModel.price.toInt()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 50,
            ),
            decoration: BoxDecoration(
              color: AppColors.greenColor,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Text(
              "ADD CART",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return Container(
      width: 20,
      height: 20,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        RatingBar(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          onRatingUpdate: (rating) {
            print(rating);
          },
          ratingWidget: RatingWidget(
            full: Icon(Icons.star, color: Colors.amber),
            empty: Icon(Icons.star, color: Colors.grey[200]),
            half: Icon(Icons.star_half_outlined, color: Colors.amber),
          ),
        ),
        SizedBox(width: 16),
        Text(
          "134 Reviews",
          style: TextStyle(color: Colors.black26),
        )
      ],
    );
  }
}
