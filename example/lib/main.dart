import 'package:flutter/material.dart';
import 'package:flutter_mpesa_package/enums.dart';
import 'package:flutter_mpesa_package/flutter_mpesa_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  FlutterMpesa.initFlutterMpesa(
    consumerKey: "",
    consumerSecret: "",
    securityCredential: "",
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
              FlutterMpesa.accessToken(isLive: false)
                  .then((value) => debugPrint(value));
            },
            child: const Text("ACCESS TOKEN"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.generateQRCode(
                merchantName: "EIJI",
                amount: 1,
                referenceNumber: "referenceNumber",
                creditPartyIdentifier: "23rw455",
                qrTransactionType: QRTransactionType.bg,
                size: 300,
                isLive: false,
              ).then((value) {
                debugPrint(value);
                setState(() {
                  qrText = value;
                });
              });
            },
            child: const Text("GENERATE QR CODE"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.lipaNaMpesa(
                businessShortCode: 174379,
                phoneNumber: 254000000000,
                amount: 1,
                callBackUrl: "https://mydomain.com/path",
                passKey: "YOUR PASS KEY",
                accountReference: "EIJI",
                transactionDescription: "transactionDescription",
                isLive: false,
              ).then((value) => debugPrint(value.toString()));
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
                isLive: false,
              ).then((value) => debugPrint(value.toString()));
            },
            child: const Text("CUSTOMER TO BUSINESS REGISTER URL"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.businessToCustomer(
                businessShortCode: 600988,
                recipientPhoneNumber: 254000000000,
                amount: 1,
                b2cPaymentType: B2CPaymentType.salaryPayment,
                initiatorName: "initiatorName",
                queueTimeOutUrl: "https://mydomain.com/b2c/queue",
                resultUrl: "https://mydomain.com/b2c/result",
                remarks: "remarks",
                occasion: "occasion",
                isLive: false,
              ).then((value) => debugPrint(value.toString()));
            },
            child: const Text("BUSINESS TO CUSTOMER"),
          ),
          ElevatedButton(
            onPressed: () {
              FlutterMpesa.transactionStatus(
                initiator: "HELLO",
                transactionId: "OEI2AK4Q16",
                partyA: 254000000000,
                transactionStatusIdentifierType:
                    TransactionStatusIdentifierType.organizationShortCode,
                queueTimeOutUrl:
                    'https://mydomain.com/TransactionStatus/queue/',
                resultUrl: 'https://mydomain.com/TransactionStatus/result/',
                occasion: 'occasion',
                remarks: 'OK',
                isLive: false,
              ).then((value) => debugPrint(value.toString()));
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
                isLive: false,
              ).then((value) => debugPrint(value.toString()));
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
                occasion: "occasion",
                reversalReceiverIdentifierType:
                    ReversalReceiverIdentifierType.tillNumber,
                isLive: false,
              ).then((value) => debugPrint(value.toString()));
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
                isLive: false,
              ).then((value) => debugPrint(value.toString()));
            },
            child: const Text("REVERSE TRANSACTION"),
          ),
        ],
      ),
    );
  }
}
