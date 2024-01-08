import 'package:cocktails/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchModal extends StatefulWidget {
  static const List<String> suggestions = [
    'Mojito',
    'Margarita',
    'Whisky',
    'Light',
    'Fresh',
    'Fruity',
  ];

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
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
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
        child: Container(
            width: MediaQuery.of(context).size.height,
            color: getPrimColor(context).withOpacity(0.6),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildLastSearches(),
                  SizedBox(height: 20),
                  ..._buildSuggestions(),
                  SizedBox(height: 20),
                ],
              ),
            ))),
      ),
    ]);
  }

  List<Widget> _buildLastSearches() {
    return [
      Text(
        'last_searches'.tr,
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
          4,
          (index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                child: Text(
                  'drink_name'.trParams({'number': '$index'}),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      )
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
          SearchModal.suggestions.length,
          (index) {
            return GestureDetector(
              onTapUp: (details) {
                _openSearchResults();
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
                    SearchModal.suggestions[index],
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
      )
    ];
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
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
            height: 50,
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

  void _openSearchResults() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: getPrimColor(context).withOpacity(0.6),
        child: Center(
          child: Text(
            'search_results'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
