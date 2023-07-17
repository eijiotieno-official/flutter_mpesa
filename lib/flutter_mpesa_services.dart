import 'dart:convert';
import 'package:flutter_mpesa/flutter_mpesa.dart';
import 'package:http/http.dart' as http;

class FlutterMpesa {
  //These lines declare three static variables: _consumerKey, _consumerSecret, and _securityCredential. The static keyword means that these variables belong to the class itself rather than an instance of the class. They are also nullable (String?), meaning they can hold either a string value or null.

  static String? _consumerKey;
  static String? _consumerSecret;
  static String? _securityCredential;

  // This is a static method named passConsumerCredentials that takes three required arguments: consumerKey, consumerSecret, and securityCredential. It doesn't return anything (void).

  static void passConsumerCredentials({
    required String consumerKey,
    required String consumerSecret,
    required String securityCredential,
  }) {
    // The purpose of this method is to set the consumer credentials for accessing the M-Pesa Daraja API. The values for consumerKey, consumerSecret, and securityCredential are provided as arguments to the method.

    _consumerKey = consumerKey;
    _consumerSecret = consumerSecret;
    _securityCredential = securityCredential;
  }

  /// Retrieves an access token from the M-Pesa Daraja API for authentication.
  ///
  /// Returns the access token as a [String] if the request is successful, otherwise returns [null].
  /// Throws an [Exception] with the error message if the request fails.

  /*This function retrieves an access token from the M-Pesa Daraja API for authentication purposes. Here's a breakdown of what the function does:

It encodes the consumer key and consumer secret using base64 encoding.
Prepares the headers for the HTTP request, including the encoded credentials.
Defines the URL to request the access token from the API.
Sends a GET request to the token URL with the prepared headers.
Decodes the response body into a map.
If the response status code is not 200, it throws an exception with the error message received.
If the response status code is 200, it returns the access token from the response body.
You can use this function to obtain an access token required for subsequent requests to the M-Pesa Daraja API. */

  static Future<String?> accessToken() async {
    // Encode consumer key and consumer secret using base64
    String credentials =
        base64.encode(utf8.encode('$_consumerKey:$_consumerSecret'));

    // Prepare headers for the HTTP request
    Map<String, String> headers = {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json'
    };

    // Set the URL to request the access token
    String tokenUrl =
        'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';

    // Send a GET request to the token URL with the headers
    final response = await http.get(Uri.parse(tokenUrl), headers: headers);

    // Decode the response body into a map
    Map<String, dynamic> responseData = json.decode(response.body);

    // Check if the response status code is not 200 (OK)
    if (response.statusCode != 200) {
      throw Exception(responseData['errorMessage']);
    }

    // Return the access token if the response status code is 200
    return response.statusCode != 200 ? null : responseData['access_token'];
  }

  /// Generates a QR code for a transaction using the M-Pesa Daraja API.
  ///
  /// Generates a QR code with the specified parameters and returns the response data as a [Map] if successful.
  /// Throws an [Exception] with the error message if the request fails.
  ///
  /* It declares a nullable responseData variable to store the response data.
It awaits the accessToken() function to obtain the access token required for authentication.
If the access token is not null, it proceeds with generating the QR code.
It sets the URL for generating the QR code.
It prepares the request body with the specified parameters, such as merchant name, amount, reference number, credit party identifier, QR transaction type, and size.
It sets the headers for the HTTP request, including the access token obtained earlier.
It sends a POST request to the QR code generation URL with the headers and request body.
It decodes the response body into a map.
If the response status code is not 200, it throws an exception with the error message received.
If the response status code is 200, it assigns the response body to the responseData variable.
Finally, it returns the responseData if available.*/
  static Future<Map> generateQR({
    required String merchantName,
    required int amount,
    required String referenceNumber,
    required String creditPartyIdentifier,
    required QRTransactionType qrTransactionType,
    required int size,
  }) async {
    Map? responseData;

    // Obtain an access token
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          // Set the URL to generate the QR code
          String qrUrl =
              'https://sandbox.safaricom.co.ke/mpesa/qrcode/v1/generate';

          // Prepare the request body with the specified parameters
          Map<String, dynamic> requestBody = {
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

          // Set the headers for the HTTP request, including the access token
          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          // Send a POST request to the QR code generation URL with the headers and request body
          final response = await http.post(Uri.parse(qrUrl),
              headers: headers, body: json.encode(requestBody));

          // Decode the response body into a map
          Map body = json.decode(response.body);

          // Check if the response status code is not 200 (OK)
          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );

    // Return the response data if available
    return responseData!;
  }

  /// Initiates a Lipa na M-Pesa (Pay with M-Pesa) transaction using the M-Pesa Daraja API.
  ///
  /// Initiates a Lipa na M-Pesa transaction with the specified parameters and returns the response data as a [Map] if successful.
  /// Throws an [Exception] with the error message if the request fails.
  static Future<Map> lipaNaMpesa({
    required int businessShortCode,
    required int phoneNumber,
    required int amount,
    required String passKey,
    required String callBackUrl,
    required String accountReference,
    required String transactionDescription,
  }) async {
    Map? responseData;

    // Obtain an access token
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          // Set the URL for initiating the Lipa na M-Pesa transaction
          String lipaNaMpesaUrl =
              'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';

          // Prepare the request body with the specified parameters
          Map<String, dynamic> requestBody = {
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

          // Set the headers for the HTTP request, including the access token
          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          // Send a POST request to initiate the Lipa na M-Pesa transaction with the headers and request body
          final response = await http.post(
            Uri.parse(lipaNaMpesaUrl),
            headers: headers,
            body: json.encode(requestBody),
          );

          // Decode the response body into a map
          Map body = json.decode(response.body);

          // Check if the response status code is not 200 (OK)
          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );

    // Return the response data if available
    return responseData!;
  }

  /// Registers a Customer to Business (C2B) URL for receiving transaction callbacks from the M-Pesa Daraja API.
  ///
  /// Registers a C2B URL with the specified parameters and returns the response data as a [Map] if successful.
  /// Throws an [Exception] with the error message if the request fails.
  static Future<Map> customerToBusinessRegisterUrl({
    required int businessShortCode,
    required C2BRegisterUrlResponseType c2bRegisterUrlResponseType,
    required String confirmationUrl,
    required String validationUrl,
  }) async {
    Map? responseData;

    // Obtain an access token
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          // Set the URL for registering the C2B URL
          String c2bRegisterUrl =
              'https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl';

          // Prepare the request body with the specified parameters
          Map<String, dynamic> requestBody = {
            "ShortCode": businessShortCode.toString(),
            "ResponseType": c2bRegisterUrlResponseType ==
                    C2BRegisterUrlResponseType.completed
                ? "Completed"
                : "Cancelled",
            "ConfirmationURL": confirmationUrl,
            "ValidationURL": validationUrl,
          };

          // Set the headers for the HTTP request, including the access token
          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          // Send a POST request to register the C2B URL with the headers and request body
          final response = await http.post(
            Uri.parse(c2bRegisterUrl),
            headers: headers,
            body: json.encode(requestBody),
          );

          // Decode the response body into a map
          Map body = json.decode(response.body);

          // Check if the response status code is not 200 (OK)
          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );

    // Return the response data if available
    return responseData!;
  }

  /// Initiates a Business to Customer (B2C) transaction using the M-Pesa Daraja API.
  ///
  /// Initiates a B2C transaction with the specified parameters and returns the response data as a [Map] if successful.
  /// Throws an [Exception] with the error message if the request fails.
  static Future<Map> businessToCustomer({
    required int businessShortCode,
    required int recipientPhoneNumber,
    required int amount,
    required B2CPaymentType b2cPaymentType,
    required String initiatorName,
    required String queueTimeOutUrl,
    required String resultUrl,
    required String remarks,
    required String occassion,
  }) async {
    Map? responseData;

    // Obtain an access token
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          // Set the URL for initiating the B2C transaction
          String businessToCustomerUrl =
              'https://sandbox.safaricom.co.ke/mpesa/b2c/v1/paymentrequest';

          // Prepare the request body with the specified parameters
          Map<String, dynamic> requestBody = {
            'InitiatorName': initiatorName,
            'SecurityCredential': _securityCredential,
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
            'Occassion': occassion,
          };

          // Set the headers for the HTTP request, including the access token
          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          // Send a POST request to initiate the B2C transaction with the headers and request body
          final response = await http.post(
            Uri.parse(businessToCustomerUrl),
            headers: headers,
            body: json.encode(requestBody),
          );

          // Decode the response body into a map
          Map body = json.decode(response.body);

          // Check if the response status code is not 200 (OK)
          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );

    // Return the response data if available
    return responseData!;
  }

  /// Checks the status of a transaction using the M-Pesa Daraja API.
  ///
  /// Checks the status of a transaction with the specified parameters and returns the response data as a [Map] if successful.
  /// Throws an [Exception] with the error message if the request fails.
  static Future<Map> transactionStatus({
    required String initiator,
    required String transactionId,
    required int partyA,
    required String resultUrl,
    required String queueTimeOutUrl,
    required TransactionStatusIdentifierType transactionStatusIdentifierType,
    required String remarks,
    required String occassion,
  }) async {
    Map? responseData;

    // Obtain an access token
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          // Set the URL for querying the transaction status
          String transactionQueryUrl =
              'https://sandbox.safaricom.co.ke/mpesa/transactionstatus/v1/query';

          // Prepare the request body with the specified parameters
          Map<String, dynamic> requestBody = {
            "Initiator": initiator,
            "SecurityCredential": _securityCredential,
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
            "Occasion": occassion,
          };

          // Set the headers for the HTTP request, including the access token
          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          // Send a POST request to query the transaction status with the headers and request body
          final response = await http.post(Uri.parse(transactionQueryUrl),
              headers: headers, body: json.encode(requestBody));

          // Decode the response body into a map
          Map body = json.decode(response.body);

          // Check if the response status code is not 200 (OK)
          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );

    // Return the response data if available
    return responseData!;
  }

  /// Retrieves the account balance using the M-Pesa Daraja API.
  ///
  /// Retrieves the account balance with the specified parameters and returns the response data as a [Map] if successful.
  /// Throws an [Exception] with the error message if the request fails.
  static Future<Map> accountBalance({
    required String initiator,
    required AccountBalanceIdentifierType accountBalanceIdentifierType,
    required int partyA,
    required String resultUrl,
    required String queueTimeOutUrl,
    required String remarks,
  }) async {
    Map? responseData;

    // Obtain an access token
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          // Set the URL for querying the account balance
          String accountBalanceQueryUrl =
              'https://sandbox.safaricom.co.ke/mpesa/accountbalance/v1/query';

          // Prepare the request body with the specified parameters
          Map<String, dynamic> requestBody = {
            "Initiator": initiator,
            "SecurityCredential": _securityCredential,
            "CommandID": "AccountBalance",
            "PartyA": partyA.toString(),
            "IdentifierType": accountBalanceIdentifierType ==
                    AccountBalanceIdentifierType.msisdn
                ? "1"
                : accountBalanceIdentifierType ==
                        AccountBalanceIdentifierType.tillNumber
                    ? "2"
                    : "3",
            "ResultURL": resultUrl,
            "QueueTimeOutURL": queueTimeOutUrl,
            "Remarks": remarks,
          };

          // Set the headers for the HTTP request, including the access token
          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          // Send a POST request to query the account balance with the headers and request body
          final response = await http.post(Uri.parse(accountBalanceQueryUrl),
              headers: headers, body: json.encode(requestBody));

          // Decode the response body into a map
          Map body = json.decode(response.body);

          // Check if the response status code is not 200 (OK)
          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );

    // Return the response data if available
    return responseData!;
  }

  /// Initiates a transaction reversal using the M-Pesa Daraja API.
  ///
  /// Initiates a transaction reversal with the specified parameters and returns the response data as a [Map] if successful.
  /// Throws an [Exception] with the error message if the request fails.
  static Future<Map> reversal({
    required String initiator,
    required int amount,
    required String transactionID,
    required int receiverParty,
    required ReversalReceiverIdentifierType reversalReceiverIdentifierType,
    required String resultUrl,
    required String queueTimeOutUrl,
    required String remarks,
    required String occassion,
  }) async {
    Map? responseData;

    // Obtain an access token
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          // Set the URL for initiating the transaction reversal
          String reversalQueryUrl =
              'https://sandbox.safaricom.co.ke/mpesa/reversal/v1/request';

          // Prepare the request body with the specified parameters
          Map<String, dynamic> requestBody = {
            "Initiator": initiator,
            "SecurityCredential": _securityCredential,
            "CommandID": "TransactionReversal",
            "TransactionID": transactionID,
            "Amount": amount.toString(),
            "ReceiverParty": receiverParty.toString(),
            "RecieverIdentifierType": reversalReceiverIdentifierType ==
                    ReversalReceiverIdentifierType.msisdn
                ? "6"
                : reversalReceiverIdentifierType ==
                        ReversalReceiverIdentifierType.tillNumber
                    ? "11"
                    : "4",
            "ResultURL": resultUrl,
            "QueueTimeOutURL": queueTimeOutUrl,
            "Remarks": remarks,
            "Occasion": occassion,
          };

          // Set the headers for the HTTP request, including the access token
          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          // Send a POST request to initiate the transaction reversal with the headers and request body
          final response = await http.post(Uri.parse(reversalQueryUrl),
              headers: headers, body: json.encode(requestBody));

          // Decode the response body into a map
          Map body = json.decode(response.body);

          // Check if the response status code is not 200 (OK)
          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );

    // Return the response data if available
    return responseData!;
  }

  static Future<Map> taxRemittance({
    required String initiator,
    required int amount,
    required TaxRemittanceSenderIdentifierType
        taxRemittanceSenderIdentifierType,
    required TaxRemittanceReceiverIdentifierType
        taxRemittanceReceiverIdentifierType,
    required int partyA,
    required int partyB,
    required String accountReference,
    required String resultUrl,
    required String queueTimeOutUrl,
    required String remarks,
  }) async {
    Map? responseData;
    await accessToken().then(
      (accessToken) async {
        if (accessToken != null) {
          String remittaxUrl =
              'https://sandbox.safaricom.co.ke/mpesa/b2b/v1/remittax';

          Map<String, dynamic> requestBody = {
            "Initiator": initiator,
            "SecurityCredential": _securityCredential,
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

          Map<String, String> headers = {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          };

          final response = await http.post(Uri.parse(remittaxUrl),
              headers: headers, body: json.encode(requestBody));

          Map body = json.decode(response.body);

          if (response.statusCode != 200) {
            throw Exception(body['errorMessage']);
          } else {
            responseData = body;
          }
        }
      },
    );
    return responseData!;
  }
}
