// Import necessary packages and enums
import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

// Function to register a callback URL for C2B transactions
Future<Map<String, dynamic>> customerToBusinessRegisterUrlFunction({
  required int
      businessShortCode, // Business short code for the C2B registration.
  required C2BRegisterUrlResponseType
      c2bRegisterUrlResponseType, // Response type for the registration.
  required String confirmationUrl, // Callback URL for completed transactions.
  required String validationUrl, // Callback URL for validation.
  required bool
      isLive, // Flag indicating whether the environment is live or not.
}) async {
  // Obtain an access token for authorization.
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant C2B registration details.
  Map<String, dynamic> body = {
    "ShortCode": businessShortCode.toString(),
    "ResponseType":
        c2bRegisterUrlResponseType == C2BRegisterUrlResponseType.completed
            ? "Completed"
            : "Cancelled",
    "ConfirmationURL": confirmationUrl,
    "ValidationURL": validationUrl,
  };

  // Set the headers for the HTTP request, including the access token.
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for registering the C2B callback URL.
  String url = getUrl(isLive: isLive, endPoint: 'mpesa/c2b/v1/registerurl');

  // Make a POST request to register the C2B callback URL using the postRequest function.
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the response data.
  return responseData;
}
