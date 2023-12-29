import 'package:cocktails/models/filter.dart';
import 'package:cocktails/utils/widgets/filter_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocktailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  final bool isFilterButton;
  final Function(Filter)? onFilterSelected;
  final Filter? defaultFilter;
  final List<Filter>? filters;

  CocktailsAppBar(
      {super.key,
      this.title = 'Cocktails',
      this.isBackButton = false,
      this.isFilterButton = false,
      this.onFilterSelected,
      this.defaultFilter,
      this.filters});

  @override
  Widget build(BuildContext context) {
    if (isBackButton) {
      return AppBar(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTapUp: (details) {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 24.0,
            ),
          ),
        ),
        actions: [
          if (isFilterButton &&
              onFilterSelected != null &&
              filters != null &&
              filters!.isNotEmpty)
            GestureDetector(
              onTapUp: (details) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FilterSelectorModal(
                      filters: filters!,
                      defaultFilter: defaultFilter ?? Filter.defaultFilter,
                      onSelected: onFilterSelected!,
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xffF7F8F8),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.filter_alt,
                  color: Colors.black,
                  size: 24.0,
                ),
              ),
            ),
        ],
      );
    }

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
