import 'package:cocktails/models/filter.dart';
import 'package:cocktails/utils/widgets/filter_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocktailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  final bool isFilterButton;
  final Function(Filter)? onFilterSelected;
  final Rx<Filter>? defaultFilter;
  final List<Filter>? filters;
  final bool isFilter; // true if filter, false if sort

  CocktailsAppBar(
      {super.key,
      this.title = 'Cocktails',
      this.isBackButton = false,
      this.isFilterButton = false,
      this.isFilter = true,
      this.onFilterSelected,
      this.defaultFilter,
      this.filters});

  @override
  Widget build(BuildContext context) {
    if (isBackButton) {
      return AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
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
              borderRadius: BorderRadius.circular(10),
            ),
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
                      isFilter: isFilter,
                      filters: filters!,
                      defaultFilter:
                          defaultFilter?.value ?? Filter.defaultFilter,
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    isFilter ? Icons.filter_alt : Icons.sort,
                    color: Colors.black,
                    size: 24.0,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
