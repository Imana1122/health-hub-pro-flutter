import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class WeightPlanService extends BaseApi {
  var authProvider = AuthProvider();
  WeightPlanService(this.authProvider);

  Future<dynamic> getWeightPlans() async {
    var url = 'account/weight-plans';
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> setGoal({required String goal}) async {
    var url = 'account/choose-goal';
    String token = authProvider.user.token;

    var body = {
      'weight_plan_id': goal,
    };
    return await api.httpPost(url, body: body, token: token);
  }
}
