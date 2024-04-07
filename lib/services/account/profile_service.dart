import 'package:fyp_flutter/services/base_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileService extends BaseApi {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000/api';

  Future<dynamic> getCuisines({required String token}) async {
    var url = 'account/cuisines';
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getAllergens({required String token}) async {
    var url = 'account/allergens';
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getHealthConditions({required String token}) async {
    var url = 'account/health-conditions';
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> setCuisines(
      {required List cuisines, required String token}) async {
    var url = 'account/set-cuisine-preferences';
    var body = {'cuisines': cuisines};
    return await api.httpPost(url, body: body, token: token);
  }

  Future<dynamic> setAllergens({
    required List allergens,
    required String token,
  }) async {
    var url = 'account/set-allergens';

    var body = {
      'allergens': allergens,
    };

    return await api.httpPost(url, body: body, token: token);
  }

  Future<dynamic> setHealthConditions(
      {required List healthConditions, required String token}) async {
    var url = 'account/set-health-conditions';

    var body = {
      'healthConditions': healthConditions,
    };
    return await api.httpPost(url, body: body, token: token);
  }

  Future<dynamic> logMeal(
      {required String recipeId, required String token}) async {
    var url = 'account/log-meal';
    String now = DateTime.now().toIso8601String();

    var body = {'recipe_id': recipeId, 'created_at': now};
    print(body);
    return await api.httpPost(url, body: body, token: token);
  }

  Future<dynamic> deleteLogMeal(
      {required String id, required String token}) async {
    var url = 'account/deleteMealLog/$id';
    String now = DateTime.now().toIso8601String();

    var body = {'created_at': now};

    return await api.httpDelete(url, body: body, token: token);
  }

  Future<dynamic> getMealLogs({required String token}) async {
    String now = DateTime.now().toIso8601String();
    var url = 'account/get-meal-logs/$now';

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getSpecificMealLogs(
      {required String datetime, required String token}) async {
    var url = 'account/get-meal-logs/$datetime';

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> changeNotification({required String token}) async {
    var url = 'account/update-notification';

    var body = {};
    return await api.httpPost(url, body: body, token: token);
  }
}
