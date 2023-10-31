import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

// Function for initiating a Business to Customer (B2C) transaction
Future<Map<String, dynamic>> businessToCustomerFunction({
  required int businessShortCode, // Business short code initiating the payment
  required int recipientPhoneNumber, // Phone number of the recipient
  required int amount, // Amount to be sent in the transaction
  required B2CPaymentType
      b2cPaymentType, // Type of B2C payment (Business, Salary, Promotion)
  required String initiatorName, // Name of the initiator (API user)
  required String queueTimeOutUrl, // URL for timeout notification
  required String resultUrl, // URL for result notification
  required String
      remarks, // Additional information associated with the transaction
  required String
      occasion, // Additional information associated with the transaction
  required bool
      isLive, // Flag indicating whether the environment is live or not
}) async {
  // Obtain an access token for authorization.
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant B2C payment details.
  Map<String, dynamic> body = {
    'InitiatorName': initiatorName,
    'SecurityCredential': FlutterMpesa.keys!.securityCredential,
    'CommandID': b2cPaymentType == B2CPaymentType.businessPayment
        ? "BusinessPayment"
        : b2cPaymentType == B2CPaymentType.salaryPayment
            ? "SalaryPayment"
            : "PromotionPayment",
    'Amount': amount.toString(),
    'PartyA': businessShortCode.toString(),
    'PartyB': recipientPhoneNumber.toString(),
    'QueueTimeOutURL': queueTimeOutUrl,
    'ResultURL': resultUrl,
    'Remarks': remarks,
    'Occassion': occasion,
  };

  // Set the headers for the HTTP request, including the access token.
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for initiating the B2C payment request.
  String url = getUrl(isLive: isLive, endPoint: 'mpesa/b2c/v1/paymentrequest');

  // Make a POST request to initiate the B2C payment using the postRequest function.
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the response data.
  return responseData;
}
