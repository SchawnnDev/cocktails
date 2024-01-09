import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/drink_recipe_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class DrinkCard extends StatefulWidget {
  final Drink drink;
  final int index;
  final Color? singleColor;
  final bool twoRowsSize;

  const DrinkCard(this.drink, this.index, {super.key, this.singleColor, this.twoRowsSize = false});

  @override
  State<DrinkCard> createState() => _DrinkCardState();
}

class _DrinkCardState extends State<DrinkCard> {

  double calculateWidth() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 600) {
      return 140;
    }
    return (screenWidth - 3 * 15) / 2;
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.twoRowsSize ? calculateWidth() : 140.0;
    return Stack(children: [
      Container(
          width: width,
          height: 205,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: widget.singleColor ??
                primColor(context, widget.index),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 110,
                width: width,
                child: CachedNetworkImage(
                  imageUrl: widget.drink.thumbnail ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 110,
                      width: width,
                      // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  '${widget.drink.strDrink ?? 'No name'}\n',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            splashColor: Color(0x00542E71).withOpacity(0.2),
            highlightColor: Color(0x00542E71).withOpacity(0.3),
            onTapUp: (TapUpDetails details) {
              DrinkRecipeModal.show(context, widget.drink);
            },
          ),
        ),
      ),
      Positioned(
        left: 10,
        bottom: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.drink.strAlcoholic != null) ...[
              Icon(
                widget.drink.strAlcoholic == "Alcoholic"
                    ? Icons.local_bar
                    : Icons.no_drinks,
                size: 20,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
            ],
            if (widget.drink.ingredients.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${widget.drink.ingredients.length}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.liquor,
                    size: 20,
                    color: Colors.black,
                  )
                ],
              ),
            ],
          ],
        ),
      ),
      Positioned(
        right: 10,
        bottom: 10,
        child: GestureDetector(
          onTapUp: (details) {
            widget.drink.favorite.toggle();
          },
          child: Obx(() => Icon(
                widget.drink.favorite.value
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: widget.drink.favorite.value
                    ? Colors.redAccent
                    : Colors.black,
                size: widget.twoRowsSize ? 26 : 22,
              )),
        ),
      ),
    ]);
  }
}
