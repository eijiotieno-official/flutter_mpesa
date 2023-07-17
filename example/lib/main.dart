import 'package:flutter/material.dart';
import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  FlutterMpesa.passConsumerCredentials(
    consumerKey: "[]",
    consumerSecret: "[]",
    securityCredential: "[]",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? qrText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (qrText != null)
            QrImageView(
              data: qrText!,
              size: 200,
            ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.accessToken().then((value) {
                print(value);
              });
            },
            child: const Text("ACCESS TOKEN"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.generateQR(
                merchantName: "EIJI",
                amount: 1,
                referenceNumber: "referenceNumber",
                creditPartyIdentifier: "23rw455",
                qrTransactionType: QRTransactionType.bg,
                size: 300,
              ).then((value) {
                print(value);
                setState(() {
                  qrText = value['qrcode'];
                });
              });
            },
            child: const Text("GENERATE QR CODE"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.lipaNaMpesa(
                businessShortCode: 174379,
                phoneNumber: 254706733999,
                amount: 1,
                callBackUrl: "https://mydomain.com/path",
                passKey: "[YOUR PASS KEY]",
                accountReference: "EIJI",
                transactionDescription: "transactionDescription",
                // accountNumber: '24356',
              ).then((value) => print(value));
            },
            child: const Text("MPESA EXPRESS (LIPA NA MPESA)"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.customerToBusinessRegisterUrl(
                businessShortCode: 600983,
                c2bRegisterUrlResponseType:
                    C2BRegisterUrlResponseType.completed,
                confirmationUrl: "https://mydomain.com/confirmation",
                validationUrl: "https://mydomain.com/validation",
              ).then((value) => print(value));
            },
            child: const Text("CUSTOMER TO BUSINESS REGISTER URL"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.businessToCustomer(
                businessShortCode: 600988,
                recipientPhoneNumber: 254706733999,
                amount: 1,
                b2cPaymentType: B2CPaymentType.salaryPayment,
                initiatorName: "initiatorName",
                queueTimeOutUrl: "https://mydomain.com/b2c/queue",
                resultUrl: "https://mydomain.com/b2c/result",
                remarks: "remarks",
                occassion: "occassion",
              ).then((value) => print(value));
            },
            child: const Text("BUSINESS TO CUSTOMER"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.transactionStatus(
                initiator: "HELLO",
                transactionId: "OEI2AK4Q16",
                partyA: 254706733999,
                transactionStatusIdentifierType:
                    TransactionStatusIdentifierType.organizationShortCode,
                queueTimeOutUrl:
                    'https://mydomain.com/TransactionStatus/queue/',
                resultUrl: 'https://mydomain.com/TransactionStatus/result/',
                occassion: 'occassion',
                remarks: 'OK',
              ).then((value) => print(value));
            },
            child: const Text("TRANSACTION STATUS"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.accountBalance(
                initiator: "initiator",
                accountBalanceIdentifierType:
                    AccountBalanceIdentifierType.tillNumber,
                partyA: 600426,
                resultUrl: "https://mydomain.com/AccountBalance/result/",
                queueTimeOutUrl: "https://mydomain.com/AccountBalance/queue/",
                remarks: "remarks",
              ).then((value) => print(value));
            },
            child: const Text("RETRIEVE ACCOUNT BALANCE"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.reversal(
                initiator: "initiator",
                amount: 5,
                transactionID: "OEI2AK4Q16",
                receiverParty: 600992,
                resultUrl: "https://mydomain.com/Reversal/queue/",
                queueTimeOutUrl: "https://mydomain.com/Reversal/result/",
                remarks: "remarks",
                occassion: "occassion",
                reversalReceiverIdentifierType:
                    ReversalReceiverIdentifierType.tillNumber,
              ).then((value) => print(value));
            },
            child: const Text("REVERSE TRANSACTION"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.taxRemittance(
                initiator: "initiator",
                amount: 1,
                resultUrl: "https://mydomain.com/Reversal/queue/",
                queueTimeOutUrl: "https://mydomain.com/Reversal/result/",
                remarks: "remarks",
                accountReference: '',
                partyA: 2334,
                partyB: 9866,
                taxRemittanceReceiverIdentifierType:
                    TaxRemittanceReceiverIdentifierType.msisdn,
                taxRemittanceSenderIdentifierType:
                    TaxRemittanceSenderIdentifierType.tillNumber,
              ).then((value) => print(value));
            },
            child: const Text("REVERSE TRANSACTION"),
          ),
        ],
      ),
    );
  }
}
