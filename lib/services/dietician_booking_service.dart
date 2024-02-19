import 'dart:convert';
import 'dart:io';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DieticianBookingService {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000/api';
  var authProvider = AuthProvider();
  DieticianBookingService(this.authProvider);

  Future<dynamic> getDieticians(
      {int currentPage = 1, String keyword = ''}) async {
    var url = '$baseUrl/account/get-dieticians?page=$currentPage';

    // Append keyword and category parameters if they are not empty
    if (keyword != '') {
      url += '&keyword=$keyword';
    }
    String token = authProvider.user.token;
    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data['dieticians'];
      } else {
        print("Error");
        throw Exception('Failed to get');
      }
    } else {
      print("Failed to connect");
      throw Exception('Failed to connect');
    }
  }

  Future<dynamic> bookDietician({
    required String dieticianId,
  }) async {
    var url = '$baseUrl/account/book-dieticians';
    String token = authProvider.user.token;

    var headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: token,
    };

    var body = jsonEncode({
      'dietician_id': dieticianId,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        // Check if the 'userAllergens' key exists and is not empty
        if (data.containsKey('data')) {
          Fluttertoast.showToast(
            msg: "Successfully initiated booking.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: TColor.secondaryColor1,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          try {
            EsewaFlutterSdk.initPayment(
              esewaConfig: EsewaConfig(
                environment: Environment.test,
                clientId: dotenv.env['CLIENT_ID'] ?? '',
                secretId: dotenv.env['SECRET_KEY'] ?? '',
              ),
              esewaPayment: EsewaPayment(
                productId: data['data']['id'],
                productName: data['data']['dietician']['first_name'] +
                    data['data']['dietician']['last_name'],
                productPrice:
                    data['data']['dietician']['booking_amount'].toString(),
                callbackUrl: '',
              ),
              onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
                debugPrint(":::SUCCESS::: => $data");
                bool result = await verifyTransactionStatus(data);
                return result;
              },
              onPaymentFailure: (data) {
                Fluttertoast.showToast(
                  msg: "Booking Payment Failed.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                debugPrint(":::FAILURE::: => $data");
              },
              onPaymentCancellation: (data) {
                Fluttertoast.showToast(
                  msg: "Booking Payment Cancelled.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                debugPrint(":::CANCELLATION::: => $data");
              },
            );
          } on Exception catch (e) {
            debugPrint("EXCEPTION : ${e.toString()}");
          }
        } else {
          Fluttertoast.showToast(
            msg: "Dietician booking not initiated.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false; // Return an empty list if no allergens are found
        }
      } else {
        if (data.containsKey('error')) {
          Fluttertoast.showToast(
            msg: data[
                'error'], // Concatenate elements with '\n' (newline) separator
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

      throw Exception('Failed to connect');
    }
  }

  Future<bool> verifyTransactionStatus(EsewaPaymentSuccessResult result) async {
    var response = await callVerificationApi(result.refId);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      debugPrint("Response Code => ${map[0]['transactionDetails']['status']}");
      if (map[0]['transactionDetails']['status'] == 'COMPLETE') {
        var url = '$baseUrl/account/verify-booking-payment';
        String token = authProvider.user.token;

        var headers = {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: token,
        };

        var body = jsonEncode({
          'productId': map[0]['productId'],
          'totalAmount': map[0]['totalAmount'],
          'status': map[0]['transactionDetails']['status'],
          'refId': map[0]['transactionDetails']['referenceId'],
          'date': DateTime.now().toIso8601String(),
        });
        print("Body: $body");

        var response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == true) {
            Fluttertoast.showToast(
              msg: "Dietician successfully booked.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: TColor.secondaryColor1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return true;
          } else {
            if (data.containsKey('error')) {
              Fluttertoast.showToast(
                msg: data[
                    'error'], // Concatenate elements with '\n' (newline) separator
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              print("${data['error']}");
              return false;
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

              print("${data['errors']}");
              return false;
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
          print('Failed to connect');
          return false;
        }
      } else {
        Fluttertoast.showToast(
          msg: "Dietician booking failed.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        ); // Handle Txn Verification Failure
        return false;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Dietician booking failed.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  Future<http.Response> callVerificationApi(String refId) async {
    final String merchantId = dotenv.env['CLIENT_ID'] ?? '';
    final String merchantSecret = dotenv.env['SECRET_KEY'] ?? '';

    // Construct the URL with the refId
    String url = 'https://rc.esewa.com.np/mobile/transaction?txnRefId=$refId';

    // Construct headers with merchantId and merchantSecret
    Map<String, String> headers = {
      'merchantId': merchantId,
      'merchantSecret': merchantSecret,
      'Content-Type': 'application/json',
    };

    // Make the GET request
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }
}
