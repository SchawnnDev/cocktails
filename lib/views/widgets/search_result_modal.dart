import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultModal extends StatefulWidget {
  final String what;

  SearchResultModal({super.key, required this.what});

  static void show(BuildContext context, String what) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) => SearchResultModal(
        what: what,
      ),
    );
  }

  @override
  State<SearchResultModal> createState() => _SearchResultModalState();
}

class _SearchResultModalState extends State<SearchResultModal> {
  final _drinks = <Drink>[].obs;
  final _ingredients = <Ingredient>[].obs;
  late Future _future;

  List<Drink> get drinks => _drinks;

  List<Ingredient> get ingredients => _ingredients;

  @override
  void initState() {
    super.initState();
    _future = fetchWhat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: getPrimColor(context),
        centerTitle: true,
        title: Text(
          widget.what,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 54,
        leading: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          // Adjust the duration as needed
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getPrimColor(context).withOpacity(0.6),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.close_outlined),
            color: Get.isDarkMode ? Colors.white : Colors.black,
            style: ButtonStyle(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: _buildFutureBody(_future),
    );
  }

  Widget _buildBody() {
    if (drinks.isEmpty && ingredients.isEmpty) {
      return _noMatches();
    }

    return Container(
      color: getPrimColor(context).withOpacity(0.6),
      constraints: BoxConstraints.expand(),
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Flexible(
                      child: Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        alignment: WrapAlignment.spaceEvenly,
                        children: List.generate(
                          drinks.length,
                          (index) {
                            final drink = drinks[index];

                            return DrinkCard(
                              drink,
                              index,
                              singleColor: Colors.white70,
                              twoRowsSize: true,
                            );
                          },
                        ),
                      ),
                    ),
                    if (ingredients.isNotEmpty) ...[
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ingredients'.tr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          itemCount: ingredients.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          separatorBuilder: (context, index) => SizedBox(
                            width: 25,
                          ),
                          itemBuilder: (context, index) {
                            return _ingredientsSectionItem(
                                ingredients[index], index);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _noMatches() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/molotov.png',
            width: 72,
            height: 72,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'no_results'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchWhat() async {
    final dataProvider = Get.find<PersistentDataProvider>();
    final drinks = await dataProvider.searchDrinks(widget.what);
    final ingredients = await dataProvider.searchIngredients(widget.what);
    ingredients.addAll(await dataProvider.searchIngredients('${widget.what} '));
    ingredients.addAll(await dataProvider.searchIngredients(' ${widget.what}'));
    _drinks(drinks);
    _ingredients(ingredients);
    await Future.delayed(
        Duration(milliseconds: 250)); // small delay to avoid flickering
  }

  Widget _buildFutureBody(Future future) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            Get.snackbar(
              'error_happened'.tr,
              'search_drink_error'.tr,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Color(0xFFCC0000).withOpacity(0.6),
              colorText: Colors.white,
              icon: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              shouldIconPulse: true,
            );
            Navigator.pop(context);
            return Center(
              child: Text(
                'error'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return _buildBody();
        } else {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Stack _ingredientsSectionItem(Ingredient ingredient, int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          decoration: BoxDecoration(
              color: primColor(context, index),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: ingredient.getLittleImageUrl(),
                    imageBuilder: (context, imageProvider) => Container(
                      height: 40,
                      width: 40,
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
                        width: 50,
                        height: 50,
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
                  '${ingredient.name.tr}\n',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
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
    );
  }
}
