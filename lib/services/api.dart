import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_flutter/common/color_extension.dart';

class Api {
  static final _api = Api._internal();

  factory Api() {
    return _api;
  }

  Api._internal();

  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000';
  String path = 'api';

  Future<dynamic> httpPost(String endPath,
      {required String token, required Object body}) async {
    String url = '$baseUrl/$path/$endPath';
    print("URL::: $url");
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    String bodyJson = json.encode(body);

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: bodyJson,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        if (data.containsKey('message')) {
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: TColor.secondaryColor1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        if (data.containsKey('data')) {
          return data['data'];
        } else {
          return data['status'];
        }
      } else {
        if (data.containsKey('message')) {
          Fluttertoast.showToast(
            msg: data[
                'message'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join(
                '\n\n'), // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(response.body);
    }
  }

  Future<dynamic> httpPut(String endPath,
      {required String token, required Object body}) async {
    String url = '$baseUrl/$path/$endPath';
    print(url);

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    String bodyJson = json.encode(body);

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: bodyJson,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        if (data.containsKey('message')) {
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: TColor.secondaryColor1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        if (data.containsKey('data')) {
          print(data['data']);
          return data['data'];
        } else {
          return data['status'];
        }
      } else {
        if (data.containsKey('message')) {
          Fluttertoast.showToast(
            msg: data[
                'message'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join(
                '\n\n'), // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(response.body);
    }
  }

  Future<dynamic> httpDelete(String endPath,
      {Object? body, required String token}) async {
    String url = '$baseUrl/$path/$endPath';
    print(url);

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    http.Response response;

    if (body != null) {
      String bodyJson = json.encode(body);
      response =
          await http.delete(Uri.parse(url), headers: headers, body: bodyJson);
    } else {
      response = await http.delete(Uri.parse(url), headers: headers);
    }

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        if (data.containsKey('message')) {
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: TColor.secondaryColor1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        if (data.containsKey('data')) {
          print(data['data']);
          return data['data'];
        } else {
          return data['status'];
        }
      } else {
        if (data.containsKey('message')) {
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join('\n\n'),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(response.body);
    }
  }

  Future<dynamic> httpGet(String endPath, {required String token}) async {
    String url = '$baseUrl/$path/$endPath';
    print(url);

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        print(data['data']);
        return data['data'];
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception(response.body);
    }
  }

  Future<dynamic> guestPost(
    String endPath,
    Object body,
  ) async {
    String url = '$baseUrl/$path/$endPath';
    print(url);
    var headers = {
      'Content-Type': 'application/json',
    };
    String bodyJson = json.encode(body);

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: bodyJson,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColor.secondaryColor1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return data['status'];
      } else {
        if (data.containsKey('message')) {
          Fluttertoast.showToast(
            msg: data[
                'message'], // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['error']}");
        } else {
          Map<String, dynamic> errorMap = data['errors'];
          List<String> errorMessages = [];

          errorMap.forEach((field, errors) {
            for (var error in errors) {
              errorMessages.add('$field: $error');
            }
          });

          Fluttertoast.showToast(
            msg: errorMessages.join(
                '\n\n'), // Concatenate elements with '\n' (newline) separator
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          throw Exception("${data['errors']}");
        }
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to connect.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(response.body);
    }
  }

  Future<dynamic> guestGet(String endPath) async {
    String url = '$baseUrl/$path/$endPath';
    print(url);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data['data'];
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception(response.body);
    }
  }

  Future<http.Response> conversationGet(String endPath,
      {required String token}) async {
    String url = '$baseUrl/$path/$endPath';
    final response = await http.get(Uri.parse(url), headers: {
      'content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(url);
    print(response.body);

    return response;
  }

  Future<http.Response> conversationPost(String endPath,
      {required String token, required Object body}) async {
    String uri = '$baseUrl/$path/$endPath';
    String bodyJson = json.encode(body);

    final response = await http.post(Uri.parse(uri),
        headers: {
          'content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyJson);
    print(response.body);

    return response;
  }
}
