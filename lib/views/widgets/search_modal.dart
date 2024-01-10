import 'package:cocktails/controllers/search_controller.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:cocktails/views/widgets/search_result_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const SearchModal(),
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
    );
  }
}

class _SearchModalState extends State<SearchModal> {
  final searchModalController = SearchModalController();

  @override
  void initState() {
    super.initState();
    searchModalController.fetchBuzzingDrinks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildHeader(context),
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: getPrimColor(context).withOpacity(0.6),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              maxLines: 1,
              onSubmitted: (value) {
                _openSearchResults(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
                hintText: 'search_cocktail_hint'.tr,
                hintStyle: TextStyle(color: Color(0xffDDDADA)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    color: getPrimColor(context).withOpacity(0.6),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildLastSearches(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildSuggestions(),
                          ),
                        ),
                        if (searchModalController.buzzingDrinks.isNotEmpty) ...[
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              color: getPrimColor(context).withOpacity(0.8),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildBuzzingRecipes(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        // Use Expanded for Buzzing Recipes to allow it to take up remaining space
      ],
    );
  }

  List<Widget> _buildLastSearches() {
    if (searchModalController.lastSearches.isEmpty) {
      return [];
    }
    return [
      Text(
        'last_searches'.tr,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),
      Obx(
        () => Wrap(
          spacing: 15,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: List.generate(
            searchModalController.lastSearches.length,
            (index) {
              return GestureDetector(
                onTapUp: (details) {
                  _openSearchResults(searchModalController.lastSearches[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Text(
                      searchModalController.lastSearches[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      SizedBox(height: 20),
    ];
  }

  List<Widget> _buildSuggestions() {
    return [
      Text(
        'suggestions'.tr,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),
      Wrap(
        spacing: 15,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: List.generate(
          SearchModalController.suggestions.length,
          (index) {
            return GestureDetector(
              onTapUp: (details) {
                _openSearchResults(SearchModalController.suggestions[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 8.0),
                  child: Text(
                    SearchModalController.suggestions[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(height: 20),
    ];
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: getPrimColor(context).withOpacity(0.6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'search_cocktail'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SizedBox(
            height: 60,
            child: GestureDetector(
              onTapUp: (details) {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.expand_more_outlined,
                size: 36,
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _buildBuzzingRecipes() {
    return [
      Text(
        'buzzing_recipes'.tr,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),
      Expanded(
        child: Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.center,
              children: List.generate(
                searchModalController.buzzingDrinks.length,
                (index) {
                  return DrinkCard(
                    searchModalController.buzzingDrinks[index],
                    index,
                    twoRowsSize: true,
                    singleColor: Colors.white70,
                  );
                },
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
    ];
  }

  void _openSearchResults(String what) {
    if (what.isEmpty) return;
    if (what.length > 45) what = what.substring(0, 45);
    searchModalController.addLastSearch(what);
    SearchResultModal.show(
      context,
      what,
    );
  }
}
