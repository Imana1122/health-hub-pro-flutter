import 'dart:convert';
import 'dart:io';
import 'package:fyp_flutter/models/meal_type.dart';
import 'package:fyp_flutter/models/recipe_category.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class RecipeRecommendationService {
  String baseUrl = 'http://10.0.2.2:8000/api';
  var authProvider = AuthProvider();
  RecipeRecommendationService(this.authProvider);

  Future<dynamic> getRecipeRecommendations({required String mealTypeId}) async {
    var url = '$baseUrl/account/recipe-recommendations/$mealTypeId';
    String token = authProvider.user.token;
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        var recipeRecommendations = data['recipes'];

        return recipeRecommendations;
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<List<RecipeCategory>> getRecipeCategories() async {
    var url = '$baseUrl/account/recipe-categories';
    String token = authProvider.user.token;
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        List<dynamic> recipeCategoriesDataList = data['recipeCategories'];
        List<RecipeCategory> recipeCategories = recipeCategoriesDataList
            .map((recipeCategoriesData) =>
                RecipeCategory.fromJson(recipeCategoriesData))
            .toList();

        return recipeCategories;
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<List<MealType>> getMealTypes() async {
    var url = '$baseUrl/account/recipe-meal-types';
    String token = authProvider.user.token;
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        List<dynamic> recipeMealTypesDataList = data['recipeMealTypes'];
        print(recipeMealTypesDataList);
        List<MealType> recipeMealTypes = recipeMealTypesDataList
            .map(
                (recipeMealTypesData) => MealType.fromJson(recipeMealTypesData))
            .toList();

        return recipeMealTypes;
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }
}
