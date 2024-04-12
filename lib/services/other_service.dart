import 'package:fyp_flutter/services/base_api.dart';

class OtherService extends BaseApi {
  Future<dynamic> getTermsAndConditions({required int currentPage}) async {
    var url = 'terms-and-conditions?page=$currentPage';

    return await api.guestGet(url);
  }

  Future<dynamic> getContact() async {
    var url = 'contact';

    return await api.guestGet(url);
  }
}
