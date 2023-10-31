import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

// Define a function for initiating a reversal transaction
Future<Map<String, dynamic>> reversalFunction({
  // The name of the initiator to initiate the request.
  required String initiator,

  // The amount transacted in the transaction is to be reversed, down to the cent.
  required int amount,

  // This is the Mpesa Transaction ID of the transaction which you wish to reverse.
  required String transactionID,

  // The organization that receives the transaction.
  required int receiverParty,

  // Type of organization that receives the transaction.
  required ReversalReceiverIdentifierType reversalReceiverIdentifierType,

  // The path that stores information about the transaction.
  required String resultUrl,

  // The path that stores information about the time-out transaction.
  required String queueTimeOutUrl,

  // Comments that are sent along with the transaction.
  required String remarks,

  // Optional Parameter: Sequence of characters up to 100.
  required String occasion,

  // A flag indicating whether the operation is being performed in a live environment.
  required bool isLive,
}) async {
  // Obtain an access token for authorization
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant reversal details
  Map<String, dynamic> body = {
    "Initiator": initiator,
    "SecurityCredential": FlutterMpesa.keys!.securityCredential,
    "CommandID": "TransactionReversal",
    "TransactionID": transactionID,
    "Amount": amount.toString(),
    "ReceiverParty": receiverParty.toString(),
    "RecieverIdentifierType":
        reversalReceiverIdentifierType == ReversalReceiverIdentifierType.msisdn
            ? "6"
            : reversalReceiverIdentifierType ==
                    ReversalReceiverIdentifierType.tillNumber
                ? "11"
                : "4",
    "ResultURL": resultUrl,
    "QueueTimeOutURL": queueTimeOutUrl,
    "Remarks": remarks,
    "Occasion": occasion,
  };

  // Set the headers for the HTTP request, including the access token
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for initiating the reversal transaction
  String url = getUrl(isLive: isLive, endPoint: 'mpesa/reversal/v1/request');

  // Make a POST request to initiate the reversal transaction
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the response data
  return responseData;
}
