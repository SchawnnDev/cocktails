import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/settings_controller.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/utils/consts.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/utils/widgets/badge_pill.dart';
import 'package:cocktails/utils/widgets/invisible_expanded_header.dart';
import 'package:cocktails/utils/widgets/quantity_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class DrinkRecipeModal extends StatefulWidget {
  final Drink drink;
  static const instructionFontSize = 16.0;
  static const instructionStepFontSize = 15.0;

  DrinkRecipeModal({super.key, required this.drink});

  @override
  State<DrinkRecipeModal> createState() => _DrinkRecipeModalState();

  static void show(BuildContext ctx, Drink drink) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) => DrinkRecipeModal(
        drink: drink,
      ),
    );
  }
}

class _DrinkRecipeModalState extends State<DrinkRecipeModal> {
  var headerVisible = false;
  var quantity = 1.obs;
  final settingsController = Get.find<SettingsController>();
  Drink? drink;
  var canShare = true;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Get.find<PersistentDataProvider>();
    drink ??= widget.drink;

    if (drink!.isFullyLoaded) {
      return _buildModal(drink!, context);
    }

    return FutureBuilder(
      future: dataProvider.getDrink(widget.drink.idDrink),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: Text('No connection'));
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null) {
              Get.snackbar(
                'error_happened'.tr,
                'get_drink_error'.tr,
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
              return Center(child: Text('Error'));
            }
            drink = snapshot.data;
            return _buildModal(drink!, context);
        }
      },
    );
  }

  CustomScrollView _buildModal(Drink drink, BuildContext context) {
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 240.0,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              color: (Get.isDarkMode ? Colors.black : Colors.white)
                  .withOpacity(headerVisible ? 1 : 0),
              child: Padding(
                padding: const EdgeInsets.only(left: 65, right: 65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InvisibleExpandedHeader(
                      child: Text(
                        drink.strDrink!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onVisibilityChanged: (v) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            setState(() {
                              headerVisible = v;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            titlePadding: EdgeInsets.zero,
            centerTitle: true,
            background: _buildSpaceBarBackground(drink),
            collapseMode: CollapseMode.pin,
          ),
          automaticallyImplyLeading: false,
          leadingWidth: 54,
          leading: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            // Adjust the duration as needed
            margin: EdgeInsets.only(left: 5, top: headerVisible ? 0 : 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Get.isDarkMode ? Colors.black : Colors.white,
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
          actions: [
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              //width: 48,
              margin: EdgeInsets.only(right: 5, top: headerVisible ? 0 : 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Get.isDarkMode ? Colors.black : Colors.white,
              ),
              child: IconButton(
                icon: Obx(
                  () => drink.favorite.value
                      ? Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        )
                      : Icon(Icons.favorite_border_outlined),
                ),
                onPressed: () {
                  drink.favorite.toggle();
                },
                //  splashRadius: 26,
              ),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: _buildTitleContainer(drink),
        ),
        SliverToBoxAdapter(
          child: _buildShareContainer(drink),
        ),
        SliverToBoxAdapter(
          child: _buildIngredientsContainer(drink),
        ),
        SliverToBoxAdapter(
          child: _buildInstructionsContainer(drink),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            color: Color(0xFFBAA9DB).withOpacity(0.3),
          ),
        )
      ],
    );
  }

  Container _buildInstructionsContainer(Drink drink) {
    final locale = Rx<Locale?>(Get.locale);
    return Container(
      color: Color(0xFFBAA9DB).withOpacity(0.3),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 100),
      child: Column(
        children: [
          Text(
            'instructions'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          ObxValue((p0) {
            var instructions = drink
                .getInstructions(p0.value?.languageCode.toUpperCase() ?? 'EN');
            if (instructions.isEmpty) {
              return Text('No instructions :(');
            }
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: drink.instructions['EN']!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index + 1 == drink.instructions['EN']!.length
                              ? 'final_step'.tr
                              : '${'step'.tr} ${index + 1}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: DrinkRecipeModal.instructionStepFontSize,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          index >= drink.instructions['EN']!.length
                              ? ''
                              : drink.instructions['EN']![index],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: DrinkRecipeModal.instructionFontSize,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }, locale),
        ],
      ),
    );
  }

  Container _buildIngredientsContainer(Drink drink) {
    return Container(
      color: Color(0xFFBAA9DB).withOpacity(0.6),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
      child: Column(
        children: [
          Text(
            'ingredients'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTapUp: (details) {
              showModalBottomSheet(
                context: context,
                builder: (context) => QuantitySelectorModal(
                  defaultQuantity: quantity.value,
                  onSelected: (int a) {
                    setState(
                      () {
                        quantity(a);
                      },
                    );
                  },
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'for'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                BadgePill(
                  frontIcon: Icon(
                    Icons.unfold_more,
                    size: 14,
                  ),
                  text: '$quantity x',
                  textStyle: TextStyle(fontWeight: FontWeight.w600),
                  color: Color(0xff4472c4),
                  verticalPadding: 1,
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 30,
            // Adjust the spacing between items
            runSpacing: 10,
            // Adjust the run spacing (spacing between rows)
            children: List.generate(
              drink.ingredients.length,
              (index) => SizedBox(
                width: 80, // Adjust the width as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75, // Adjust the width as needed
                      height: 75, // Adjust the height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              drink.ingredients[index].getLittleImageUrl(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 70,
                            width: 70,
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
                              width: 70,
                              height: 70,
                              // Adjust the height as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Obx(() => Text(
                          multiplyMeasure(
                            drink.ingredients[index].measure?.trim() ?? '1x',
                            quantity.value,
                            settingsController.measureInOz.value,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    // ),
                    SizedBox(height: 5),
                    Text(
                      drink.ingredients[index].name.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTitleContainer(Drink drink) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Container(
        color: Color(0xFFBAA9DB).withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              Text(
                drink.strDrink!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 120,
                child: Divider(
                  thickness: 4,
                  color: getPrimColor(context),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (drink.strGlass != null)
                BadgePill(
                  text: drink.strGlass!,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  textStyle: TextStyle(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w200),
                  backIcon: Icon(
                    Icons.wine_bar_outlined,
                    color: Get.isDarkMode ? Colors.black : Colors.white,
                    size: 16,
                  ),
                ),
              SizedBox(
                height: drink.strGlass == null ? 10 : 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSpaceBarBackground(Drink drink) {
    return Container(
      color: Color(0xFFBAA9DB).withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 40),
        child: Column(
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CachedNetworkImage(
                imageUrl: drink.strDrinkThumb ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFFBAA9DB),
                        style: BorderStyle.solid,
                        width: 4),
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
                    height: 100,
                    // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildShareContainer(Drink drink) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Container(
        color: Color(0xFFBAA9DB).withOpacity(0.3),
        padding: EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTapUp: (details) {
            if (!canShare) {
              return;
            }
            setState(() {
              canShare = false;
            });
            Share.share("🍹 ${'share_1'.tr} "
                "${drink.strDrink!} 🎉🥳\n"
                " ${'share_2'.tr} 🍸🌟"
                " ${'share_3'.tr}\n\n"
                "📲 ${getAppUrl()}");
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                canShare = true;
              });
            });
          },
          child: Column(children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.ios_share,
                      size: 24,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'share'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      drink.favorites,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTapUp: (details) {
                        drink.favorite.toggle();
                      },
                      child: Obx(
                        () => Icon(
                          drink.favorite.value
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: drink.favorite.value
                              ? Colors.redAccent
                              : (Get.isDarkMode ? Colors.white : Colors.black),
                          size: 24,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  /* ===================== UTILS  ===================== */

  String formatNumber(double number) {
    if (number == number.toInt().toDouble()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(2);
    }
  }

  String multiplyMeasure(String measure, int factor, bool measureInOz) {
    final regex = RegExp(r"([0-9./]+)\s*([a-zA-Z]+|)");
    final match = regex.firstMatch(measure);

    if (match != null && match.group(1) != null && match.group(2) != null) {
      var number = match.group(1)!.contains('/')
          ? double.parse(match.group(1)!.split('/')[0]) /
              double.parse(match.group(1)!.split('/')[1])
          : double.parse(match.group(1)!);

      number *= factor;
      var name = (match.group(2) ?? '').tr;

      if (!measureInOz && name == 'oz') {
        number *= 2.95735;
        name = 'cl';
      }

      addName(String name) {
        if (name.isNotEmpty) {
          return ' $name';
        }
        return '';
      }

      number = number.toPrecision(2);

      switch (number) {
        case 0.1:
          return '1/10${addName(name)}';
        case 0.2:
          return '1/5${addName(name)}';
        case 0.25:
          return '1/4${addName(name)}';
        case 0.33:
          return '1/3${addName(name)}';
        case 0.4:
          return '2/5${addName(name)}';
        case 0.5:
          return '1/2${addName(name)}';
        case 0.67:
          return '2/3${addName(name)}';
        case 0.75:
          return '3/4${addName(name)}';
        case 0.8:
          return '4/5${addName(name)}';
        default:
          return formatNumber(number) + addName(name);
      }
    }

    return measure;
  }
}
