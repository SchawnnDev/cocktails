import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/swipe_controller.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SwipePageBinding extends Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() => SwipeController(
        drinks: dataProvider.randomDrinks)); // TODO: Change this
  }
}

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final AppinioSwiperController controller = AppinioSwiperController();
  final SwipeController swipeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final SwipeController swipeController = Get.find();
    return Scaffold(
      appBar: CocktailsAppBar(title: 'swipe'.tr, isBackButton: false),
      bottomNavigationBar: NavBar(
        index: 2,
        animate: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ObxValue(
                (more) => more.value
                    ? Center(child: CircularProgressIndicator())
                    : AppinioSwiper(
                        controller: controller,
                        cardCount: swipeController.drinks.length,
                        onEnd: () {
                          swipeController.loadMore();
                        },
                        onSwipeEnd: (index, index2, swipeDirection) {},
                        cardBuilder: (BuildContext context, int index) {
                          final drink = swipeController.drinks[index];
                          return _swipeCard(drink, index);
                        },
                      ),
                swipeController.loadingMore,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            IconTheme.merge(
              data: const IconThemeData(size: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  swipeLeftButton(controller),
                  const SizedBox(
                    width: 20,
                  ),
                  swipeRightButton(controller),
                  const SizedBox(
                    width: 20,
                  ),
                  unswipeButton(controller),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _swipeCard(Drink drink, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Flexible(
              child: CachedNetworkImage(
            imageUrl: drink.strDrinkThumb ?? '',
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
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
                // Adjust the height as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drink.strDrink ?? 'No name',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (drink.strAlcoholic ?? 'No alcoholic info').tr,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget swipeRightButton(AppinioSwiperController controller) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final SwiperPosition? position = controller.position;
        final SwiperActivity? activity = controller.swipeActivity;
        final double progress = (activity is Swipe || activity == null) &&
                position != null &&
                position.offset.toAxisDirection().isHorizontal
            ? position.progressRelativeToThreshold.clamp(-1, 1)
            : 0;
        final Color color = Color.lerp(
          CupertinoColors.activeGreen,
          CupertinoColors.systemGrey2,
          (-1 * progress).clamp(0, 1),
        )!;
        return GestureDetector(
          onTap: () {
            if (swipeController.loadingMore.value) return;
            controller.swipeRight();
          },
          child: Transform.scale(
            scale: 1 + .1 * progress.clamp(0, 1),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.9),
                    spreadRadius: -10,
                    blurRadius: 20,
                    offset: const Offset(0, 20), // changes position of shadow
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.favorite_border_outlined,
                color: CupertinoColors.white,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget swipeLeftButton(AppinioSwiperController controller) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final SwiperPosition? position = controller.position;
        final SwiperActivity? activity = controller.swipeActivity;
        final double horizontalProgress =
            (activity is Swipe || activity == null) &&
                    position != null &&
                    position.offset.toAxisDirection().isHorizontal
                ? -1 * position.progressRelativeToThreshold.clamp(-1, 1)
                : 0;
        final Color color = Color.lerp(
          const Color(0xFFFF3868),
          CupertinoColors.systemGrey2,
          (-1 * horizontalProgress).clamp(0, 1),
        )!;
        return GestureDetector(
          onTap: () {
            if (swipeController.loadingMore.value) return;
            controller.swipeLeft();
          },
          child: Transform.scale(
            // Increase the button size as we swipe towards it.
            scale: 1 + .1 * horizontalProgress.clamp(0, 1),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.9),
                    spreadRadius: -10,
                    blurRadius: 20,
                    offset: const Offset(0, 20), // changes position of shadow
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.close,
                color: CupertinoColors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget unswipeButton(AppinioSwiperController controller) {
    return GestureDetector(
      onTap: () {
        if (swipeController.loadingMore.value) return;
        controller.unswipe();
      },
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        child: const Icon(
          Icons.rotate_left_rounded,
          color: CupertinoColors.systemGrey2,
        ),
      ),
    );
  }
}
