import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class MealPlanService extends BaseApi {
  var authProvider = AuthProvider();
  MealPlanService(this.authProvider);

  Future<dynamic> getMealPlans({
    int currentPage = 1,
  }) async {
    var url = 'account/meal-plan-recommendations?page=$currentPage';

    String token = authProvider.user.token;

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> selectMealPlan(
      {required String mealPlanId, required String token}) async {
    var url = 'account/select-meal-plan';
    String now = DateTime.now().toIso8601String();

    var body = {'meal_plan_id': mealPlanId, 'created_at': now};
    print(body);
    return await api.httpPost(url, body: body, token: token);
  }
}
