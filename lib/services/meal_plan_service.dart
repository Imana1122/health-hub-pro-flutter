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
}
