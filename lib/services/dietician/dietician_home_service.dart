import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class DieticianHomeService extends BaseApi {
  var authProvider = DieticianAuthProvider();
  DieticianHomeService(this.authProvider);

  Future<dynamic> getHomeDetails() async {
    var url = 'dietician/home-details';

    String token = authProvider.dietician.token;

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getPaymentDetails(
      {required String year, required String month, required page}) async {
    var url =
        'dietician/get-payment-details?year=$year&month=$month&page=$page';

    String token = authProvider.dietician.token;

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getPayments({required page}) async {
    var url = 'dietician/get-payments?page=$page';

    String token = authProvider.dietician.token;

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getRatings({required page}) async {
    var url = 'dietician/get-ratings?page=$page';

    String token = authProvider.dietician.token;

    return await api.httpGet(url, token: token);
  }
}
