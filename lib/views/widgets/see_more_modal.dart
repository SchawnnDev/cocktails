import 'package:cocktails/models/drink.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeeMoreModal extends StatelessWidget {
  final String title;
  final List<Drink>? drinks;
  final Future<List<Drink>>? fetchDrinks;

  SeeMoreModal(
      {super.key, required this.title, this.drinks, this.fetchDrinks}) {
    assert(drinks == null && fetchDrinks != null ||
        drinks != null && fetchDrinks == null);
  }

  static void show(BuildContext context, String title,
      {List<Drink>? drinks, Future<List<Drink>>? fetchDrinks}) {
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
      builder: (context) => SeeMoreModal(
        drinks: drinks,
        fetchDrinks: fetchDrinks,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFBAA9DB),
        centerTitle: true,
        title: Text(
          title,
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
      body: fetchDrinks == null ? _buildBody(drinks!) : _buildFutureBody(),
    );
  }

  Widget _buildBody(List<Drink> drinks) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: drinks.isEmpty
              ? _noMatches()
              : Wrap(
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
                        singleColor: Color(0xFFBAA9DB).withOpacity(0.6),
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
      child: Text(
        'no_matches'.tr,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFutureBody() {
    return FutureBuilder(
      future: fetchDrinks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildBody(snapshot.data ?? []);
        } else if (snapshot.hasError) {
          Get.snackbar(
            'error_happened'.tr,
            'get_drinks_error'.tr,
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
        } else {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
