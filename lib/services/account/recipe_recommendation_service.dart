import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/models/recipe_category.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class RecipeRecommendationService extends BaseApi {
  var authProvider = AuthProvider();
  RecipeRecommendationService(this.authProvider);

  Future<dynamic> getRecipeRecommendations(
      {required String mealTypeId,
      int currentPage = 1,
      String keyword = '',
      String category = ''}) async {
    var url = 'account/recipe-recommendations/$mealTypeId?page=$currentPage';

    // Append keyword and category parameters if they are not empty
    if (keyword != '') {
      url += '&keyword=$keyword';
    }
    if (category != '') {
      url += '&category=$category';
    }
    String token = authProvider.user.token;

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getRecipeDetails({
    required String id,
  }) async {
    var url = 'account/recipe/$id';

    String token = authProvider.user.token;

    return await api.httpGet(url, token: token);
  }

  Future<List<RecipeCategory>> getRecipeCategories() async {
    var url = 'account/recipe-categories';
    String token = authProvider.user.token;
    try {
      var result = await api.httpGet(url, token: token);
      // Check if the result is not null and is a List
      if (result != null && result is List) {
        // Map each JSON object to a RecipeCategory object
        return result.map((json) => RecipeCategory.fromJson(json)).toList();
      } else {
        // If the result is null or not a List, return an empty list
        return [];
      }
    } catch (e) {
      // If an error occurs during the HTTP request, handle it here
      print('Error fetching recipe categories: $e');
      // Return an empty list or rethrow the exception as needed
      return [];
    }
  }

  Future<List<MealType>> getMealTypes() async {
    var url = 'account/recipe-meal-types';
    String token = authProvider.user.token;
    var result = await api.httpGet(url, token: token);

    List<dynamic> jsonList = result;

    // Map each JSON object to a MealType instance
    List<MealType> mealTypes =
        jsonList.map((json) => MealType.fromJson(json)).toList();

    return mealTypes;
  }

  Future<dynamic> getMealLineChartDetails(
      {required String type,
      required String year,
      required String month}) async {
    var url = 'account/get-linechart-details/$type?year=$year&month=$month';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }
}
