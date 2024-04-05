import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';

class BookMarkService extends BaseApi {
  var authProvider = AuthProvider();
  BookMarkService(this.authProvider);

  Future<dynamic> getBookmarks(
      {required int currentPage, required String keyword}) async {
    var url = 'account/bookmarks?page=$currentPage&keyword=$keyword';

    String token = authProvider.user.token;

    return await api.httpGet(url, token: token);
  }

  Future<dynamic> bookmark({required Object body}) async {
    var url = 'account/bookmark/store';

    String token = authProvider.user.token;

    return await api.httpPost(url, token: token, body: body);
  }
}
