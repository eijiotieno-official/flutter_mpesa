import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

Future<Map<String, dynamic>> transactionStatusFunction({
  /// The name of the initiator initiating the request.
  required String initiator,

  /// Encrypted credential of the user getting transaction status.
  required String transactionId,

  /// Organization/MSISDN receiving the transaction.
  required int partyA,

  /// The path that stores information of a transaction.
  required String resultUrl,

  /// The path that stores information of timeout transaction.
  required String queueTimeOutUrl,

  /// Type of organization receiving the transaction.
  required TransactionStatusIdentifierType transactionStatusIdentifierType,

  /// Comments that are sent along with the transaction.
  required String remarks,

  /// Optional parameter for the transaction occasion.
  required String occasion,

  /// A flag indicating whether the transaction is in the live environment.
  required bool isLive,
}) async {
  // Obtain an access token for authorization.
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant transaction status details.
  Map<String, dynamic> body = {
    "Initiator": initiator,
    "SecurityCredential": FlutterMpesa.keys!.securityCredential,
    "CommandID": "TransactionStatusQuery",
    "TransactionID": transactionId,
    "PartyA": partyA.toString(),
    "IdentifierType": transactionStatusIdentifierType ==
            TransactionStatusIdentifierType.msisdn
        ? "1"
        : transactionStatusIdentifierType ==
                TransactionStatusIdentifierType.tillNumber
            ? "2"
            : "3",
    "ResultURL": resultUrl,
    "QueueTimeOutURL": queueTimeOutUrl,
    "Remarks": remarks,
    "Occasion": occasion,
  };

  // Set the headers for the HTTP request, including the access token.
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for checking the transaction status.
  String url =
      getUrl(isLive: isLive, endPoint: 'mpesa/transactionstatus/v1/query');

  // Make a POST request to check the transaction status.
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the response data.
  return responseData;
}
