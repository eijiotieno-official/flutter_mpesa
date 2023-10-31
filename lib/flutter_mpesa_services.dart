import 'package:flutter_mpesa_package/flutter_mpesa.dart';
import 'package:flutter_mpesa_package/utils/account_balance.dart';
import 'package:flutter_mpesa_package/utils/business_to_customer.dart';
import 'package:flutter_mpesa_package/utils/customer_2_business_register_url.dart';
import 'package:flutter_mpesa_package/utils/generate_qr_code.dart';
import 'package:flutter_mpesa_package/utils/lipa_na_mpesa.dart';
import 'package:flutter_mpesa_package/utils/reversal.dart';
import 'package:flutter_mpesa_package/utils/tax_remittance.dart';
import 'package:flutter_mpesa_package/utils/transaction_status.dart';

import 'utils/access_token.dart';
import 'utils/keys.dart';

// Main class for handling M-Pesa transactions
class FlutterMpesa {
  // Storage for API keys
  static Keys? keys;

  // Initialize FlutterMpesa with API credentials
  static void initFlutterMpesa({
    required String consumerKey,
    required String consumerSecret,
    required String securityCredential,
  }) =>
      keys = Keys(
        consumerKey: consumerKey,
        consumerSecret: consumerSecret,
        securityCredential: securityCredential,
      );

  // Get an access token for authorization
  static Future<String> accessToken({required bool isLive}) =>
      accessTokenFunction(isLive: isLive);

  // Generate a QR code for M-Pesa transactions
  static Future<String> generateQRCode({
    required String merchantName,
    required int amount,
    required String referenceNumber,
    required String creditPartyIdentifier,
    required QRTransactionType qrTransactionType,
    required int size,
    required bool isLive,
  }) =>
      generateQRCodeFunction(
        merchantName: merchantName,
        amount: amount,
        referenceNumber: referenceNumber,
        creditPartyIdentifier: creditPartyIdentifier,
        qrTransactionType: qrTransactionType,
        size: size,
        isLive: isLive,
      );

  // Perform Lipa Na M-Pesa transaction
  static Future<Map<String, dynamic>> lipaNaMpesa({
    required int businessShortCode,
    required int phoneNumber,
    required int amount,
    required String passKey,
    required String callBackUrl,
    required String accountReference,
    required String transactionDescription,
    required bool isLive,
  }) =>
      lipaNaMpesaFunction(
        businessShortCode: businessShortCode,
        phoneNumber: phoneNumber,
        amount: amount,
        passKey: passKey,
        callBackUrl: callBackUrl,
        accountReference: accountReference,
        transactionDescription: transactionDescription,
        isLive: isLive,
      );

  // Register a URL for Customer-to-Business transactions
  static Future<Map<String, dynamic>> customerToBusinessRegisterUrl({
    required int businessShortCode,
    required C2BRegisterUrlResponseType c2bRegisterUrlResponseType,
    required String confirmationUrl,
    required String validationUrl,
    required bool isLive,
  }) =>
      customerToBusinessRegisterUrlFunction(
        businessShortCode: businessShortCode,
        c2bRegisterUrlResponseType: c2bRegisterUrlResponseType,
        confirmationUrl: confirmationUrl,
        validationUrl: validationUrl,
        isLive: isLive,
      );

  // Perform Business-to-Customer transaction
  static Future<Map<String, dynamic>> businessToCustomer({
    required int businessShortCode,
    required int recipientPhoneNumber,
    required int amount,
    required B2CPaymentType b2cPaymentType,
    required String initiatorName,
    required String queueTimeOutUrl,
    required String resultUrl,
    required String remarks,
    required String occasion,
    required bool isLive,
  }) =>
      businessToCustomerFunction(
        businessShortCode: businessShortCode,
        recipientPhoneNumber: recipientPhoneNumber,
        amount: amount,
        b2cPaymentType: b2cPaymentType,
        initiatorName: initiatorName,
        queueTimeOutUrl: queueTimeOutUrl,
        resultUrl: resultUrl,
        remarks: remarks,
        occasion: occasion,
        isLive: isLive,
      );

  // Check transaction status
  static Future<Map<String, dynamic>> transactionStatus({
    required String initiator,
    required String transactionId,
    required int partyA,
    required String resultUrl,
    required String queueTimeOutUrl,
    required TransactionStatusIdentifierType transactionStatusIdentifierType,
    required String remarks,
    required String occasion,
    required bool isLive,
  }) =>
      transactionStatusFunction(
        initiator: initiator,
        transactionId: transactionId,
        partyA: partyA,
        resultUrl: resultUrl,
        queueTimeOutUrl: queueTimeOutUrl,
        transactionStatusIdentifierType: transactionStatusIdentifierType,
        remarks: remarks,
        isLive: isLive,
        occasion: occasion,
      );

  // Check account balance
  static Future<Map<String, dynamic>> accountBalance({
    required String initiator,
    required AccountBalanceIdentifierType accountBalanceIdentifierType,
    required int partyA,
    required String resultUrl,
    required String queueTimeOutUrl,
    required String remarks,
    required bool isLive,
  }) =>
      accountBalanceFunction(
        initiator: initiator,
        accountBalanceIdentifierType: accountBalanceIdentifierType,
        partyA: partyA,
        resultUrl: resultUrl,
        queueTimeOutUrl: queueTimeOutUrl,
        remarks: remarks,
        isLive: isLive,
      );

  // Initiate a transaction reversal
  static Future<Map<String, dynamic>> reversal({
    required String initiator,
    required int amount,
    required String transactionID,
    required int receiverParty,
    required ReversalReceiverIdentifierType reversalReceiverIdentifierType,
    required String resultUrl,
    required String queueTimeOutUrl,
    required String remarks,
    required String occasion,
    required bool isLive,
  }) =>
      reversalFunction(
        initiator: initiator,
        amount: amount,
        transactionID: transactionID,
        receiverParty: receiverParty,
        reversalReceiverIdentifierType: reversalReceiverIdentifierType,
        resultUrl: resultUrl,
        queueTimeOutUrl: queueTimeOutUrl,
        remarks: remarks,
        occasion: occasion,
        isLive: isLive,
      );

  // Initiate a tax remittance transaction
  static Future<Map<String, dynamic>> taxRemittance({
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
    required bool isLive,
  }) =>
      taxRemittanceFunction(
        initiator: initiator,
        amount: amount,
        taxRemittanceSenderIdentifierType: taxRemittanceSenderIdentifierType,
        taxRemittanceReceiverIdentifierType:
            taxRemittanceReceiverIdentifierType,
        partyA: partyA,
        partyB: partyB,
        accountReference: accountReference,
        resultUrl: resultUrl,
        queueTimeOutUrl: queueTimeOutUrl,
        remarks: remarks,
        isLive: isLive,
      );
}
