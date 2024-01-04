import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/ingredients_controller.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class IngredientsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IngredientsController());
  }
}

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final IngredientsController ingredientsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(title: 'ingredients'.tr, isBackButton: true),
      body: Container(
          constraints: BoxConstraints.expand(), child: _ingredients()),
      bottomNavigationBar: NavBar(
        animate: false,
      ),
      extendBody: true,
    );
  }

  Widget _ingredients() {
    return FutureBuilder(
        future: ingredientsController.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _ingredientsList();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _ingredientsList() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Obx(() => Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.spaceEvenly,
                  children: List.generate(
                      ingredientsController.ingredients.length, (index) {
                    return _ingredientsItem(
                        ingredientsController.ingredients[index], index);
                  }),
                )),
          ),
        ),
      ),
    );
  }

  SizedBox _ingredientsItem(Ingredient ingredient, int index) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Container(
            width: 105,
            decoration: BoxDecoration(
                color: primColor(context, index),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 65, // Adjust the width as needed
                  height: 65, // Adjust the height as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: ingredient.getLittleImageUrl(),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 65,
                        width: 65,
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
                          width: 65,
                          height: 65,
                          // Adjust the height as needed
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    '${ingredient.name}\n',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: Color(0x00542E71).withOpacity(0.2),
                highlightColor: Color(0x00542E71).withOpacity(0.3),
                onTapUp: (TapUpDetails details) {
                  Get.toNamed(
                      '/ingredient/${Uri.encodeComponent(ingredient.name)}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
