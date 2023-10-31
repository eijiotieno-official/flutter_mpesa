// Import necessary packages and modules
import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

// Define a function for initiating tax remittance to KRA
Future<Map<String, dynamic>> taxRemittanceFunction({
  // The M-Pesa API operator username.
  required String initiator,

  // The amount to be remitted as tax.
  required int amount,

  // The type of identifier for the sender.
  required TaxRemittanceSenderIdentifierType taxRemittanceSenderIdentifierType,

  // The type of identifier for the receiver.
  required TaxRemittanceReceiverIdentifierType
      taxRemittanceReceiverIdentifierType,

  // The shortcode from which the money will be deducted (sender).
  required int partyA,

  // The account to which money will be credited (receiver).
  required int partyB,

  // The payment registration number (PRN) issued by KRA.
  required String accountReference,

  // A URL that will be used to send transaction results after processing.
  required String resultUrl,

  // A URL that will be used to notify your system in case the request times out before processing.
  required String queueTimeOutUrl,

  // Any additional information to be associated with the transaction.
  required String remarks,

  // A boolean indicating whether the operation is in a live environment.
  required bool isLive,
}) async {
  // Obtain an access token for authorization.
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant tax remittance details.
  Map<String, dynamic> body = {
    "Initiator": initiator,
    "SecurityCredential": FlutterMpesa.keys!.securityCredential,
    "CommandID": "PayTaxToKRA",
    "SenderIdentifierType": taxRemittanceSenderIdentifierType ==
            TaxRemittanceSenderIdentifierType.msisdn
        ? "6"
        : taxRemittanceSenderIdentifierType ==
                TaxRemittanceSenderIdentifierType.tillNumber
            ? "11"
            : "4",
    "RecieverIdentifierType": taxRemittanceReceiverIdentifierType ==
            TaxRemittanceReceiverIdentifierType.msisdn
        ? "6"
        : taxRemittanceReceiverIdentifierType ==
                TaxRemittanceReceiverIdentifierType.tillNumber
            ? "11"
            : "4",
    "Amount": amount.toString(),
    "PartyA": partyA.toString(),
    "PartyB": partyB.toString(),
    "AccountReference": accountReference,
    "ResultURL": resultUrl,
    "QueueTimeOutURL": queueTimeOutUrl,
    "Remarks": remarks,
  };

  // Set the headers for the HTTP request, including the access token.
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for registering the C2B callback URL.
  String url = getUrl(isLive: isLive, endPoint: 'mpesa/b2b/v1/remittax');

  // Make a POST request to register the C2B callback URL using the postRequest function.
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the response data.
  return responseData;
}
