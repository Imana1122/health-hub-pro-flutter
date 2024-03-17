import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:http/http.dart' as http;

import '../base_api.dart';

class ConversationService extends BaseApi {
  Future<dynamic> getChatParticipants({required String token}) async {
    return await api.httpGet('account/chats/participants', token: token);
  }

  Future<dynamic> loadMoreMessages(
      {required int page,
      required String token,
      required String dieticianId}) async {
    return await api.httpGet('account/chats/$dieticianId?page=$page',
        token: token);
  }

  Future<dynamic> storeMessage(String message, File? file,
      {required String token, required String dieticianId}) async {
    if (file == null) {
      return await api.httpPost('account/chats/store',
          body: {'message': message, 'dietician_id': dieticianId},
          token: token);
    } else {
      var url = '${dotenv.env['BASE_URL']}/api/account/chats/store';
      print(url);

      // Create headers
      var headers = {
        'Content-Type': 'multipart/form-data',
        HttpHeaders.authorizationHeader: token
      };

      // Create a multipart request body
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      // Add fields to the request
      request.fields['dietician_id'] = dieticianId;

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      try {
        // Send the request
        var streamedResponse = await request.send();
        // Read and decode the response
        var response = await http.Response.fromStream(streamedResponse);
        // Check the response status code
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
      } catch (e) {
        // Handle any errors that occur during the request
        print("An error occurred: $e");
        throw Exception('Failed to Register');
      }
    }
  }

  Future<dynamic> readMessage(
      {required String senderId, required String token}) async {
    return await api.httpPost('account/chats/read',
        body: {'sender_id': senderId}, token: token);
  }
}
