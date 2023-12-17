import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/utils/widgets/badge_pill.dart';
import 'package:flutter/material.dart';

import 'package:cocktails/models/drink.dart';

import 'package:cocktails/utils/widgets/invisible_expanded_header.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';

class DrinkRecipeModal extends StatefulWidget {
  final Drink drink;
  static const instructionFontSize = 16.0;
  static const instructionStepFontSize = 15.0;

  DrinkRecipeModal({super.key, required this.drink});

  @override
  State<DrinkRecipeModal> createState() => _DrinkRecipeModalState();
}

class _DrinkRecipeModalState extends State<DrinkRecipeModal> {
  var headerVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 240.0,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              color: Colors.white.withOpacity(headerVisible ? 1 : 0),
              child: Padding(
                padding: const EdgeInsets.only(left: 65, right: 65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InvisibleExpandedHeader(
                        child: Text(
                          widget.drink.strDrink!,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onVisibilityChanged: (v) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              headerVisible = v;
                            });
                          });
                        }),
                  ],
                ),
              ),
            ),
            titlePadding: EdgeInsets.zero,
            centerTitle: true,
            background: _buildSpaceBarBackground(),
            collapseMode: CollapseMode.pin,
          ),
          automaticallyImplyLeading: false,
          leadingWidth: 54,
          backgroundColor: Colors.white,
          leading: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            // Adjust the duration as needed
            margin: EdgeInsets.only(left: 5, top: headerVisible ? 0 : 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close_outlined),
              color: Colors.black,
              style: ButtonStyle(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: [
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              //width: 48,
              margin: EdgeInsets.only(right: 5, top: headerVisible ? 0 : 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.favorite_outline),
                color: Colors.black,
                onPressed: () {
                  // Add your settings button functionality here
                },
              ),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: _buildTitleContainer(),
        ),
        SliverToBoxAdapter(
          child: _buildShareContainer(),
        ),
        SliverToBoxAdapter(
          child: _buildIngredientsContainer(),
        ),
        SliverToBoxAdapter(
          child: _buildInstructionsContainer(),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            color: Color(0xFFBAA9DB).withOpacity(0.6),
          ),
        )
      ],
    );
  }

  Container _buildInstructionsContainer() {
    return Container(
      color: Color(0xFFBAA9DB).withOpacity(0.6),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 100),
      child: Column(
        children: [
          Text(
            'Instructions',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          if (widget.drink.instructions['EN'] != null) // TODO: choose lang
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.drink.instructions['EN']!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index + 1 == widget.drink.instructions['EN']!.length
                              ? 'final_step'.tr
                              : '${'step'.tr} ${index + 1}',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize:
                                  DrinkRecipeModal.instructionStepFontSize),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                            index >= widget.drink.instructions['EN']!.length
                                ? ''
                                : widget.drink.instructions['EN']![index],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize:
                                    DrinkRecipeModal.instructionFontSize)),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (widget.drink.instructions['EN'] == null ||
              widget.drink.instructions['EN']!.isEmpty)
            Text('No instructions :('),
        ],
      ),
    );
  }

  Container _buildIngredientsContainer() {
    return Container(
      color: Color(0xFFBAA9DB).withOpacity(0.3),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'ingredients'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'for'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              BadgePill(
                frontIcon: Icon(
                  Icons.unfold_more,
                  size: 14,
                  color: Colors.white,
                ),
                text: '1 x',
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                color: Color(0xff4472c4),
                verticalPadding: 1,
              )
            ],
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 30,
            // Adjust the spacing between items
            runSpacing: 10,
            // Adjust the run spacing (spacing between rows)
            children: List.generate(
              widget.drink.ingredients.length,
              (index) => SizedBox(
                width: 80, // Adjust the width as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75, // Adjust the width as needed
                      height: 75, // Adjust the height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: widget.drink.ingredients[index]
                              .getLittleImageUrl(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
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
                              width: 70,
                              height: 70,
                              // Adjust the height as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    /*FittedBox(
                              fit: BoxFit.fitWidth,
                              child: */
                    Text(
                      widget.drink.ingredients[index].measure,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // ),
                    SizedBox(height: 5),
                    /*FittedBox(
                          fit: BoxFit.fitWidth,
                          child: */
                    Text(
                      widget.drink.ingredients[index].name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                    //),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTitleContainer() {
    return Container(
      color: Colors.white,
      child: Container(
        color: Color(0xFFBAA9DB).withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              Text(
                widget.drink.strDrink!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                width: 120,
                child: Divider(
                  thickness: 4,
                  color: Color(0xFFBAA9DB),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.drink.strGlass != null)
                BadgePill(
                  text: widget.drink.strGlass!,
                  color: Colors.black,
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w200),
                  backIcon: Icon(
                    Icons.wine_bar_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              SizedBox(
                height: widget.drink.strGlass == null ? 10 : 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSpaceBarBackground() {
    return Container(
      color: Color(0xFFBAA9DB).withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 40),
        child: Column(
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CachedNetworkImage(
                imageUrl: widget.drink.strDrinkThumb ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFFBAA9DB),
                        style: BorderStyle.solid,
                        width: 4),
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
                    height: 100,
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
          ],
        ),
      ),
    );
  }

  Container _buildShareContainer() {
    return Container(
      color: Color(0xFFBAA9DB).withOpacity(0.6),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTapUp: (details) {
          Share.share('Hello');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ios_share,
              size: 24,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'share'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
