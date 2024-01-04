import 'package:cocktails/models/filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterSelectorModal extends StatefulWidget {
  final bool isFilter; // true if filter, false if sort
  final Filter defaultFilter;
  final Function(Filter) onSelected;
  final List<Filter> filters;

  const FilterSelectorModal(
      {super.key,
      required this.isFilter,
      required this.filters,
      required this.defaultFilter,
      required this.onSelected});

  @override
  _FilterSelectorModalState createState() => _FilterSelectorModalState();
}

class _FilterSelectorModalState extends State<FilterSelectorModal> {
  ScrollController _scrollController = ScrollController();
  late Rx<Filter> selectedFilter = Filter.defaultFilter.obs;
  bool canClick = false;

  @override
  void initState() {
    super.initState();
    selectedFilter(widget.defaultFilter);
    canClick = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        widget.filters.indexOf(widget.defaultFilter) * 125.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF8253DB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Center(
              child: Text(
                widget.isFilter ? 'filter_by'.tr : 'sort_by'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.filters.length,
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              padding: EdgeInsets.all(15),
              separatorBuilder: (context, index) => SizedBox(
                width: 25,
              ),
              itemBuilder: (context, index) {
                final filter = widget.filters[index];
                return _filterItem(filter);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _filterItem(final Filter filter) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (!canClick) return;
          canClick = false;
          selectedFilter(filter);
          widget.onSelected(filter);
          // click effect before closing
          Future.delayed(Duration(milliseconds: 250), () {
            Get.back();
          });
        },
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: filter == selectedFilter.value
                ? Border.all(
                    color: Color(0xFF8253DB),
                    width: 3,
                  )
                : Border.all(color: Get.isDarkMode ? Colors.white : Colors.black, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(filter.imagePath)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  '${filter.name.tr}\n',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
