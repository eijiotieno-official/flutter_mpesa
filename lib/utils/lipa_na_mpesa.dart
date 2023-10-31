// Import necessary libraries and utilities.
import 'dart:convert';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

// This function initiates a Lipa Na M-Pesa transaction.
Future<Map<String, dynamic>> lipaNaMpesaFunction({
  required int
      businessShortCode, // Business short code for the transaction. Example: 174379
  required int
      phoneNumber, // Phone number associated with the transaction. Example: 254708374149
  required int amount, // Amount of the transaction. Example: 1000
  required String
      passKey, // Pass key for securing the transaction. Example: "a1b2c3d4e5f6"
  required String
      callBackUrl, // Callback URL for transaction completion notification. Example: "https://example.com/callback"
  required String
      accountReference, // Reference for the account associated with the transaction. Example: "TestAccount"
  required String
      transactionDescription, // Description of the transaction. Example: "Test transaction"
  required bool
      isLive, // Boolean flag indicating whether it's a live environment or not. Example: true
}) async {
  // Obtain an access token for authorization.
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant Lipa Na M-Pesa details.
  Map<String, dynamic> body = {
    'BusinessShortCode': businessShortCode,
    'Password': base64.encode(utf8.encode(
        '$businessShortCode$passKey${DateTime.now().toString().substring(0, 14)}')),
    'Timestamp': DateTime.now().toString().substring(0, 14),
    'TransactionType': "CustomerPayBillOnline",
    'Amount': amount.toString(),
    'PartyA': phoneNumber.toString(),
    'PartyB': businessShortCode.toString(),
    'PhoneNumber': phoneNumber.toString(),
    'CallBackURL': callBackUrl,
    'AccountReference': accountReference,
    'TransactionDesc': transactionDescription,
  };

  // Set the headers for the HTTP request, including the access token.
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for processing the Lipa Na M-Pesa transaction.
  String url =
      getUrl(isLive: isLive, endPoint: 'mpesa/stkpush/v1/processrequest');

  // Make a POST request to initiate the Lipa Na M-Pesa transaction using the postRequest function.
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the response data.
  return responseData;
}
