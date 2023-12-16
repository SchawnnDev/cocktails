import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/pages/widgets/drink_recipe_modal.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DrinkCard extends StatefulWidget {
  final Drink drink;
  final int index;

  const DrinkCard(this.drink, this.index, {super.key});

  @override
  State<DrinkCard> createState() => _DrinkCardState();
}

class _DrinkCardState extends State<DrinkCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: 140,
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color:
              Color(0xFFBAA9DB).withOpacity(widget.index % 2 == 0 ? 0.6 : 0.3),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              width: 140,
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
                    height: 130,
                    width: 130,
                    // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
              padding: const EdgeInsets.all(5),
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
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            splashColor: Color(0x00542E71).withOpacity(0.2),
            highlightColor: Color(0x00542E71).withOpacity(0.3),
            onTapUp: (TapUpDetails details) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: true,
                showDragHandle: false,
                useSafeArea: true,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                builder: (context) => DrinkRecipeModal(
                  drink: widget.drink,
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
