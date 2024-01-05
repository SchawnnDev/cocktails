import 'package:cocktails/controllers/glasses_controller.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlassesPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GlassesController());
  }
}

class GlassesPage extends StatefulWidget {
  const GlassesPage({super.key});

  @override
  State<GlassesPage> createState() => _GlassesPageState();
}

class _GlassesPageState extends State<GlassesPage> {
  final GlassesController glassesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(
        title: 'glasses'.tr,
        isBackButton: true,
        isFilterButton: true,
        isFilter: false,
        // sort
        defaultFilter: glassesController.currentFilter,
        filters: [
          Filter.defaultFilter,
          Filter.nameAscFilter,
          Filter.nameDescFilter,
        ],
        onFilterSelected: (filter) {
          glassesController.currentFilter(filter);
        },
      ),
      body: Container(constraints: BoxConstraints.expand(), child: _glasses()),
      bottomNavigationBar: NavBar(
        animate: false,
      ),
      extendBody: true,
    );
  }

  Widget _glasses() {
    return FutureBuilder(
        future: glassesController.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: ObxValue(
                (filter) {
                  var glasses = glassesController.glasses.toList();
                  if (filter.value == Filter.nameAscFilter) {
                    glasses =
                        glasses.sorted((a, b) => a.name.compareTo(b.name));
                  } else if (filter.value == Filter.nameDescFilter) {
                    glasses =
                        glasses.sorted((a, b) => b.name.compareTo(a.name));
                  }

                  return _glassesList(glasses);
                },
                glassesController.currentFilter,
              ),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _glassesList(List<Glass> glasses) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.spaceEvenly,
              children: List.generate(glasses.length, (index) {
                return _glassesItem(glasses[index], index);
              }),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _glassesItem(Glass glass, int index) {
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
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(glass.getIcon() ?? 'img/cocktail.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    '${glass.name}\n',
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
                  Get.toNamed('/glass/${Uri.encodeComponent(glass.name)}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
