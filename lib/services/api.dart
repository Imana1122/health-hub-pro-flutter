import 'package:http/http.dart' as http;

class Api {
  static final _api = Api._internal();

  factory Api() {
    return _api;
  }

  Api._internal();

  String token = '';
  String baseUrl = 'http://192.168.1.34';
  String path = 'api';

  Future<http.Response> httpGet(String endPath,
      {required Map<String, String> query}) async {
    String url = '$baseUrl/$path/$endPath';
    final response = await http.get(Uri.parse(url), headers: {
      'content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return response;
  }

  Future<http.Response> httpPost(String endPath, Object body) async {
    String uri = '$baseUrl/$path/$endPath';
    final response = await http.post(Uri.parse(uri),
        headers: {
          'content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    return response;
  }
}
