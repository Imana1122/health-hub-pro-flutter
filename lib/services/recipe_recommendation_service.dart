import 'dart:convert';
import 'dart:io';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/models/recipe_category.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';
import 'package:http/http.dart' as http;

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

  Future<List<RecipeCategory>> getRecipeCategories() async {
    var url = 'account/recipe-categories';
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<List<MealType>> getMealTypes() async {
    var url = 'account/recipe-meal-types';
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getMealLineChartDetails({required String type}) async {
    var url = 'account/get-linechart-details/$type';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }
}
