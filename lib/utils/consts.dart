import 'package:get/get.dart';

const apiBaseUrl = "https://www.thecocktaildb.com";
const apiImageUrl = "$apiBaseUrl/images/ingredients";
const apiIngredientImageUrl = "$apiImageUrl/";
const maxLastSearches = 6;


String getAppUrl() {
  if (GetPlatform.isIOS) {
    return "https://apps.apple.com/us/app/cocktails/id1577375369";
  } else if (GetPlatform.isDesktop) {
    return "https://www.schawnndev.fr/cocktails";
  } else if (GetPlatform.isWeb) {
    return "https://www.schawnndev.fr/cocktails";
  }
  return "https://play.google.com/store/apps/details?id=fr.schawnndev.cocktails";
}