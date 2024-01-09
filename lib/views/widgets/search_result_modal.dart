import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  var fetched = false;

  List<Drink> get drinks => _drinks;
  List<Ingredient> get ingredients => _ingredients;

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
      body: _buildFutureBody(),
    );
  }

  Widget _buildBody() {

    if (drinks.isEmpty && ingredients.isEmpty) {
      return _noMatches();
    }

    return Container(
      color: getPrimColor(context).withOpacity(0.6),
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
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
      ),
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
    if (fetched) {
      return;
    }
    fetched = true;
    final dataProvider = Get.find<PersistentDataProvider>();
    final drinks = await dataProvider.searchDrinks(widget.what);
    final ingredients = await dataProvider.searchIngredients(widget.what);
    _drinks(drinks);
    _ingredients(ingredients);
    await Future.delayed(Duration(milliseconds: 250)); // small delay to avoid flickering
  }

  Widget _buildFutureBody() {
    return FutureBuilder(
      future: fetched ? Future.value() : fetchWhat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
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
        }  else {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
