import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';
import 'package:flutter_mpesa_package/utils/access_token.dart';
import 'package:flutter_mpesa_package/utils/get_url.dart';
import 'package:flutter_mpesa_package/utils/post_request.dart';

Future<Map<String, dynamic>> accountBalanceFunction({
  /// The name of the initiator initiating the request.
  required String initiator,

  /// Type of organization receiving the account balance request.
  required AccountBalanceIdentifierType accountBalanceIdentifierType,

  /// Organization/MSISDN receiving the account balance request.
  required int partyA,

  /// The path that stores information of a transaction.
  required String resultUrl,

  /// The path that stores information of timeout transaction.
  required String queueTimeOutUrl,

  /// Comments that are sent along with the account balance request.
  required String remarks,

  /// A flag indicating whether the account balance request is in the live environment.
  required bool isLive,
}) async {
  // Obtain an access token for authorization.
  String token = await accessTokenFunction(isLive: isLive);

  // Prepare the request body with relevant account balance details.
  Map<String, dynamic> body = {
    "Initiator": initiator,
    "SecurityCredential": FlutterMpesa.keys!.securityCredential,
    "CommandID": "AccountBalance",
    "PartyA": partyA.toString(),
    "IdentifierType":
        accountBalanceIdentifierType == AccountBalanceIdentifierType.msisdn
            ? "1"
            : accountBalanceIdentifierType ==
                    AccountBalanceIdentifierType.tillNumber
                ? "2"
                : "3",
    "ResultURL": resultUrl,
    "QueueTimeOutURL": queueTimeOutUrl,
    "Remarks": remarks,
  };

  // Set the headers for the HTTP request, including the access token.
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  // Set the URL for checking the account balance.
  String url =
      getUrl(isLive: isLive, endPoint: 'mpesa/accountbalance/v1/query');

  // Make a POST request to check the account balance.
  Map<String, dynamic> responseData = await postRequest(
    url: url,
    headers: headers,
    body: body,
  );

  // Return the response data.
  return responseData;
}
