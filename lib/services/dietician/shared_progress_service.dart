import 'package:fyp_flutter/providers/dietician_auth_provider.dart';

import '../base_api.dart';

class SharedProgressService extends BaseApi {
  var authProvider = DieticianAuthProvider();
  SharedProgressService(this.authProvider);

  Future<dynamic> getProgress({int currentPage = 1, required String id}) async {
    var url = 'dietician/progress/$id?page=$currentPage';

    String token = authProvider.dietician.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getResult(
      {required String month1,
      required String month2,
      required String id}) async {
    var url = 'dietician/progress/result/$id?month1=$month1&month2=$month2';

    String token = authProvider.dietician.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getStat(
      {required String month1,
      required String month2,
      required String id}) async {
    var url = 'dietician/progress/stat/$id?month1=$month1&month2=$month2';

    String token = authProvider.dietician.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getChartData(
      {required String year, required String id}) async {
    var url = 'dietician/progress/line-chart-data/$id?year=$year';

    String token = authProvider.dietician.token;
    return await api.httpGet(url, token: token);
  }
}
