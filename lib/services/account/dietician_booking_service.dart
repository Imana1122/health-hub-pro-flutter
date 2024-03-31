import 'dart:convert';
import 'dart:io';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_flutter/common/color_extension.dart';
import 'package:fyp_flutter/providers/auth_provider.dart';
import 'package:fyp_flutter/views/account/dietician_subscription/payment_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../base_api.dart';

class DieticianBookingService extends BaseApi {
  var authProvider = AuthProvider();
  DieticianBookingService(this.authProvider);

  Future<dynamic> getDieticians(
      {int currentPage = 1, String keyword = ''}) async {
    var url = 'account/get-dieticians?page=$currentPage';

    // Append keyword and category parameters if they are not empty
    if (keyword != '') {
      url += '&keyword=$keyword';
    }
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> saveRating(
      {required String id, required Object body, required String token}) async {
    return await api.httpPost('account/save-rating/$id',
        body: body, token: token);
  }

  Future<dynamic> getBookedDieticians(
      {int currentPage = 1, String keyword = ''}) async {
    var url = 'account/get-booked-dieticians?page=$currentPage';

    // Append keyword and category parameters if they are not empty
    if (keyword != '') {
      url += '&keyword=$keyword';
    }
    String token = authProvider.user.token;
    return await api.httpGet(url, token: token);
  }

  Future<dynamic> bookDietician(
      {required String dieticianId, required BuildContext context}) async {
    var url = '${dotenv.env['BASE_URL']}/api/account/book-dieticians';
    String token = authProvider.user.token;
    print(url);
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
                  clientId: data['data']['dietician']['esewa_client_id'] ??
                      dotenv.env['CLIENT_ID'],
                  secretId: data['data']['dietician']['esewa_secret_key'] ??
                      dotenv.env['SECRET_KEY']),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentDetails()),
                );
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
        var url = 'account/verify-booking-payment';
        String token = authProvider.user.token;

        var headers = {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: token,
        };

        var body = {
          'productId': map[0]['productId'],
          'totalAmount': map[0]['totalAmount'],
          'status': map[0]['transactionDetails']['status'],
          'refId': map[0]['transactionDetails']['referenceId'],
          'date': DateTime.now().toIso8601String(),
        };

        return await api.httpPost(url, body: body, token: token);
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
