import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/services/base_api.dart';
import 'package:http/http.dart' as http;

class ProgressService extends BaseApi {
  var authProvider = AuthProvider();
  ProgressService(this.authProvider);

  Future<dynamic> getProgress({int currentPage = 1}) async {
    var url = 'account/progress?page=$currentPage';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getResult(
      {required String month1, required String month2}) async {
    var url = 'account/progress/result?month1=$month1&month2=$month2';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getStat(
      {required String month1, required String month2}) async {
    var url = 'account/progress/stat?month1=$month1&month2=$month2';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> getChartData({required String year}) async {
    var url = 'account/progress/line-chart-data?year=$year';

    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> saveProgress(
      {required Object body,
      required File? frontImage,
      required File? backImage,
      required File? rightImage,
      required File? leftImage}) async {
    String token = authProvider.user.token;

    var url = '${dotenv.env['BASE_URL']}/api/account/progress/store';

    // Create headers
    var headers = {
      'Content-Type': 'multipart/form-data',
      HttpHeaders.authorizationHeader: token
    };

    // Create a multipart request body
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add fields to the request
    Map<String, dynamic> bodyMap = body as Map<String, dynamic>;

    bodyMap.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    print(request.fields);
    print(url);

    request.files.add(
        await http.MultipartFile.fromPath('front_image', frontImage!.path));
    request.files
        .add(await http.MultipartFile.fromPath('back_image', backImage!.path));
    request.files.add(
        await http.MultipartFile.fromPath('right_image', rightImage!.path));
    request.files
        .add(await http.MultipartFile.fromPath('left_image', leftImage!.path));

    try {
      // Send the request
      var streamedResponse = await request.send();
      // Read and decode the response
      var response = await http.Response.fromStream(streamedResponse);
      // Check the response status code
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
    } catch (e) {
      // Handle any errors that occur during the request
      print("An error occurred: $e");
      throw Exception('Failed to save.');
    }
  }
}
