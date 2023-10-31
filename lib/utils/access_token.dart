import 'dart:convert';
import 'package:flutter_mpesa_package/utils/get_url.dart';

import 'get_request.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';

// This function retrieves an access token for the M-Pesa API.
Future<String> accessTokenFunction({required bool isLive}) async {
  try {
    // Encode consumer key and consumer secret using base64.
    String credentials = base64.encode(utf8.encode(
        '${FlutterMpesa.keys!.consumerKey}:${FlutterMpesa.keys!.consumerSecret}'));

    // Prepare headers for the HTTP request.
    Map<String, String> headers = {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json'
    };

    // Set the URL to request the access token.
    String url = getUrl(
        isLive: isLive,
        endPoint: 'oauth/v1/generate?grant_type=client_credentials');

    // Make a GET request to retrieve the access token using the custom getRequest function.
    Map<String, dynamic> responseData =
        await getRequest(url: url, headers: headers);

    // Return the access token if the response status code is 200.
    return responseData['access_token'];
  } catch (error) {
    // Handle and throw an exception for any unexpected errors during the access token retrieval.
    throw Exception('Failed to obtain access token: $error');
  }
}
