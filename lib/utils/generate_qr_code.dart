import 'package:flutter_mpesa_package/flutter_mpesa.dart';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

// This function generates a QR code for a specified transaction.
Future<String> generateQRCodeFunction({
  required String
      merchantName, // Name of the merchant initiating the transaction.
  required int amount, // Amount of the transaction.
  required String
      referenceNumber, // Unique reference number for the transaction.
  required String
      creditPartyIdentifier, // Identifier for the credit party involved.
  required QRTransactionType
      qrTransactionType, // Type of QR transaction (e.g., Pay Merchant, Withdraw Cash, etc.).
  required int size, // Size of the generated QR code image.
  required bool
      isLive, // Flag indicating whether the environment is live or not.
}) async {
  // Obtain an access token for authorization.
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant transaction details.
  Map<String, dynamic> body = {
    "MerchantName": merchantName,
    "RefNo": referenceNumber,
    "Amount": amount.toString(),
    "TrxCode": qrTransactionType
        .toString()
        .substring(qrTransactionType.toString().indexOf('.') + 1)
        .toUpperCase(),
    "CPI": creditPartyIdentifier,
    "Size": size.toString(),
  };

  // Prepare headers for the HTTP request.
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for generating the QR code.
  String url = getUrl(isLive: isLive, endPoint: 'mpesa/qrcode/v1/generate');

  // Make a POST request to generate the QR code using the postRequest function.
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the generated QR code.
  return responseData['qrcode'];
}
