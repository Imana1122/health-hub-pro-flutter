import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_flutter/models/dietician.dart';
import 'package:fyp_flutter/services/dietician/dietician_auth_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class DieticianAuthProvider with ChangeNotifier {
  late Dietician _dietician;
  bool _isLoggedIn = false;

  Dietician get dietician => _dietician;
  bool get isLoggedIn => _isLoggedIn;

  set dietician(Dietician dietician) {
    _dietician = dietician;
    notifyListeners();
  }

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<bool> register({
    required firstName,
    required lastName,
    required email,
    required phoneNumber,
    required cv,
    required image,
    required speciality,
    required description,
    required esewaClientId,
    required esewaSecretKey,
    required bookingAmount,
    required bio,
  }) async {
    try {
      bool result = await DieticianAuthService().register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        cv: cv,
        image: image,
        speciality: speciality,
        description: description,
        esewaClientId: esewaClientId,
        esewaSecretKey: esewaSecretKey,
        bookingAmount: bookingAmount,
        bio: bio,
      );

      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      Dietician dietician = await DieticianAuthService().login(
        phoneNumber: phoneNumber,
        password: password,
      );

      _dietician = dietician;
      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      try {
        await pusher.init(
            apiKey: dotenv.env['PUSHER_APP_KEY'] ?? '',
            cluster: dotenv.env['PUSHER_APP_CLUSTER'] ?? '',
            onConnectionStateChange:
                (dynamic currentState, dynamic previousState) {
              print("Connection: $currentState");
            },
            onError: (String message, int? code, dynamic e) {
              print("onError: $message code: $code exception: $e");
            },
            onSubscriptionSucceeded: (String channelName, dynamic data) {
              print("onSubscriptionSucceeded: $channelName data: $data");
            },
            onEvent: (PusherEvent event) {
              print('Received event: $event');
            },
            onSubscriptionError: (String message, dynamic e) {
              print("onSubscriptionError: $message Exception: $e");
            },
            onDecryptionFailure: (String event, String reason) {
              print("onDecryptionFailure: $event reason: $reason");
            },
            onMemberAdded: (String channelName, PusherMember member) {
              print("onMemberAdded: $channelName member: $member");
            },
            onMemberRemoved: (String channelName, PusherMember member) {
              print("onMemberRemoved: $channelName member: $member");
            },
            authEndpoint: "${dotenv.env['BASE_URL']}/api/pusher/auth",
            onAuthorizer:
                (String channelName, String socketId, dynamic options) async {
              return {
                "auth": "foo:bar",
                "channel_data": '{"user_id": 1}',
                "shared_secret": "foobar"
              };
            });
        await pusher.subscribe(channelName: 'fyp-development');
        await pusher.connect();
      } catch (e) {
        print("ERROR: $e");
      }
      _isLoggedIn = true;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      bool result =
          await DieticianAuthService().logout(token: _dietician.token);
      if (result == true) {
        _dietician = Dietician.empty();

        _isLoggedIn = false; // Set to false for logout
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePersonalInfo({
    required String bio,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      var dieticianData = await DieticianAuthService().updatePersonalInfo(
          bio: bio,
          phoneNumber: phoneNumber,
          email: email,
          token: _dietician.token);

      _dietician.firstName = dieticianData['bio'];
      _dietician.email = dieticianData['email'];
      _dietician.phoneNumber = dieticianData['phone_number'];

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      bool result = await DieticianAuthService().changePassword(
          oldPassword: oldPassword,
          password: password,
          passwordConfirmation: passwordConfirmation,
          token: _dietician.token);

      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Getter method to retrieve the authenticated dietician
  Dietician getAuthenticatedDietician() {
    return _dietician;
  }

  // Getter method to retrieve the authenticated status
  bool getAuthenticatedStatus() {
    return _isLoggedIn;
  }

  // Getter method to retrieve the authenticated token
  String getAuthenticatedToken() {
    return _dietician.token;
  }
}
