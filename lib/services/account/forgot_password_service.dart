import 'package:fyp_flutter/services/base_api.dart';

class ForgotPasswordService extends BaseApi {
  Future<dynamic> forgotPassword({required Object body}) async {
    var url = 'account/forgot-password';

    return await api.guestPost(url, body);
  }

  Future<dynamic> forgotPasswordByDietician({required Object body}) async {
    var url = 'dietician/forgot-password';

    return await api.guestPost(url, body);
  }
}
