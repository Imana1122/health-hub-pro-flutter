import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class HomeService extends BaseApi {
  var authProvider = AuthProvider();
  HomeService(this.authProvider);

  Future<dynamic> getHomeDetails() async {
    var url = 'account/home-details';

    String token = authProvider.user.token;

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getBadges() async {
    var url = 'account/badges';

    String token = authProvider.user.token;

    return await api.httpGet(url, token: token);
  }
}
