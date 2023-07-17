# Flutter Mpesa

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/eijiotieno-official/flutter_mpesa/blob/main/LICENSE)

A Flutter package that provides easy integration with the M-Pesa Daraja API for handling money transactions.

## Features

- Secure and convenient integration with the M-Pesa Daraja API.
- Authorization - generate M-pesa daraja api token
- Dynamic QR
- Mpess Express (Lipa Na Mpesa)
- CustomerToBusiness (C2B)
- BusinessToCustomer (B2C)
- Transaction Status
- Account Balance
- Reversals
- Tax Remittance

- Error handling and response parsing for seamless API interactions.
- Supports both production and sandbox (testing) environments.

## Installation

```sh
dart pub add flutter_mpesa
```

## Requirements

### Android

See the required device permissions from
the [AndroidManifest.xml](android/src/main/AndroidManifest.xml) file.

```xml
<manifest>
  ...
  <uses-permission android:name="android.permission.INTERNET" />
  ...
</manifest>
```

## Using

### initialization

Initialize the M-Pesa Daraja API with your credentials:

```dart
void main() {

FlutterMpesa.passConsumerCredentials(
    consumerKey: "[CUSTOMER KEY IN M-PESA DARAJA]",
    consumerSecret: "[CUSTOMER SECRET IN M-PESA DARAJA]",
    securityCredential: "[SECURITY CREDENTIAL IN M-PESA DARAJA]",
  );

  runApp(const MyApp());
}
```

### Access Token

Generate access token using this method, make sure you have correctly specified and initialized customerKey, consumerSecret and securityCredential provided by [<span style="color: GREEN">**M-pesa Daraja API**</span>](https://developer.safaricom.co.ke/) otherwise an exception will be thrown.

**NOTE : YOU DON'T HAVE TO CALL THIS METHOD EVERY TIME YOU USE OTHER METHODS, I ALREADY DID THAT FOR INDIVIDUAL METHODS.**

```dart
ElevatedButton(
    onPressed: () {
        FlutterMpesa.accessToken().then((value) {
            print(value);
        });
    },
    child: const Text("ACCESS TOKEN"),
),
```

### Dynamic QR

When correctly impelemeted, this method will return the QR code's data which you will use any qr code viewer package to display it.

```dart
ElevatedButton(
    onPressed: () {
        FlutterMpesa.generateQR(
        merchantName: "[MERCHANT NAME]",
        amount: "[AMOUNT]",
        referenceNumber: "[RREFERENCE NUMBER]",
        creditPartyIdentifier: "[CPI]",
        qrTransactionType: ['QRTransactionType'],
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
```

#### QR Transaction Type

```dart
enum QRTransactionType {
  //Pay Merchant (Buy Goods)
  bg,
  //Withdraw Cash at Agent Till
  wa,
  //Paybill or Business number
  pb,
  //Send Money(Mobile number)
  sm,
  //Sent to Business. Business number CPI in MSISDN format
  sb,
}
```

### M-PESA Express (Lipa Na M-pesa)

Request Parameter Description

| Name                | Description                                                                                                                                                                                         | Parameter Type | Sample Values                                                            |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|--------------------------------------------------------------------------|
| BusinessShortCode   | This is the organization's shortcode (Paybill or Buygoods - A 5 to 6-digit account number) used to identify an organization and receive the transaction.                                            | Numeric        | Shortcode (5 to 6 digits) e.g. 654321                                      |
| PhoneNumber         | The phone number sending money. The parameter expected is a Valid Safaricom Mobile Number that is M-PESA registered in the format 2547XXXXXXXX                                                     | Numeric        | MSISDN (12 digits Mobile Number) e.g. 2547XXXXXXXX                       |
| Amount              | This is the Amount transacted normally a numeric value. Money that the customer pays to the Shortcode. Only whole numbers are supported.                                                            | Numeric        | 10                                                                       |
| CallBackURL         | A CallBack URL is a valid secure URL that is used to receive notifications from M-Pesa API. It is the endpoint to which the results will be sent by M-Pesa API.                                  | URL            | <https://ip> or domain:port/path<br>e.g: <https://mydomain.com/path><br><https://0.0.0.0:9090/path> |
| AccountReference    | Account Reference: This is an Alpha-Numeric parameter that is defined by your system as an Identifier of the transaction for the CustomerPayBillOnline transaction type. Maximum of 12 characters.  | Alpha-Numeric  | Any combination of letters and numbers                                     |
| TransactionDesc     | This is any additional information/comment that can be sent along with the request from your system. Maximum of 13 Characters.                                                                       | String         | Any string between 1 and 13 characters.                                   |

```dart
  ElevatedButton(
        onPressed: () {
            FlutterMpesa.lipaNaMpesa(
            businessShortCode: "174379",
            phoneNumber: "254706733999",
            amount: "1",
            callBackUrl: "https://mydomain.com/path",
            passKey: "YOUR PASS KEY",
            accountReference: "EIJI",
            transactionDescription: "transactionDescription",
            // accountNumber: '24356',
            ).then((value) => print(value));
        },
        child: const Text("MPESA EXPRESS (LIPA NA MPESA)"),
),
```

### CustomerToBusiness (C2B)

Request Parameter Description

| Name                | Description                                                                                                                                                                                         | Type           | Sample Values                                                            |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|--------------------------------------------------------------------------|
| BusinessShortCode   | Usually, a unique number is tagged to an M-PESA pay bill/till number of the organization.                                                                                                        | Numeric        | 123456                                                                   |
| ValidationURL       | This is the URL that receives the validation request from the API upon payment submission. The validation URL is only called if the external validation on the registered shortcode is enabled. (By default External Validation is disabled).   | URL            | <https://ip> or domain:port/path                                            |
| ConfirmationURL     | This is the URL that receives the confirmation request from API upon payment completion.                                                                                                           | URL            | <https://ip> or domain:port/path                                            |
| ResponseType        | This parameter specifies what is to happen if for any reason the validation URL is not reachable. Note that, this is the default action value that determines what M-PESA will do in the scenario that your endpoint is unreachable or is unable to respond on time. Only two values are allowed: Completed or Cancelled. Completed means M-PESA will automatically complete your transaction, whereas Cancelled means M-PESA will automatically cancel the transaction, in the event M-PESA is unable to reach your Validation URL.                                                                                                                                                                                                       | String         | - Canceled<br>- Completed                                                |

```dart
ElevatedButton(
    onPressed: () {
        FlutterMpesa.customerToBusinessRegisterUrl(
        businessShortCode: "[BUSINESS SHORT CODE]",
        c2bRegisterUrlResponseType:
            ['C2BRegisterUrlResponseType'],
        confirmationUrl: "https://mydomain.com/confirmation",
        validationUrl: "https://mydomain.com/validation",
        ).then((value) => print(value));
    },
    child: const Text("CUSTOMER TO BUSINESS REGISTER URL"),
),
```

#### C2B RegisterUrl Response Type

```dart
C2BRegisterUrlResponseType.compeleted,
C2BRegisterUrlResponseType.cancelled,
```

### BusinessToCustomer (B2C)

| Name                | Description                                                                                                                                                                                         | Type           | Sample Values                                                            |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|--------------------------------------------------------------------------|
| InitiatorName        | The username of the M-Pesa B2C account API operator. NOTE: the access channel for this operator must be API and the account must be in active status.                                             | String         | initiator_1, John_Doe, John Doe                                          |
| SecurityCredential  | This is the value obtained after encrypting the API initiator password. The process for encrypting the initiator password has been described under docs, and an online encryption process is available under get test credential.                                        | Alpha-numeric  | 32SzVdmCvjpmQfw3X2RK8UAv7xuhh304dXxFC5+3lslkk2TDJY/Lh6ESVwtqMxJzF7qA== |
| CommandID            | This is a unique command that specifies the B2C transaction type. SalaryPayment: This supports sending money to both registered and unregistered M-Pesa customers. BusinessPayment: This is a normal business-to-customer payment, supporting only M-Pesa registered customers. PromotionPayment: This is a promotional payment to customers. The M-Pesa notification message is a congratulatory message. Supports only M-Pesa registered customers. | Alphanumeric   | SalaryPayment, BusinessPayment, PromotionPayment                          |
| Amount              | The amount of money being sent to the customer.                                                                                                                                                      | Number         | 30671                                                                    |
| BusinessShortCode   | This is the B2C organization shortcode from which the money is to be sent.                                                                                                                         | Number         | Shortcode (5-6 digits) e.g. 123454                                        |
| RecepientPhoneNumber| This is the customer mobile number to receive the amount. The number should have the country code (254) without the plus sign.                                                                      | Phone number   | Customer mobile number: 254722000000                                      |
| Remarks              | Any additional information to be associated with the transaction.                                                                                                                                    | String         | Sentence of up to 100 characters                                           |
| QueueTimeOutURL      | This is the URL to be specified in your request that will be used by the API Proxy to send a notification in case the payment request is timed out while awaiting processing in the queue.                                                                       | URL            | <https://ip> or domain:port/path                                            |
| ResultURL            | This is the URL to be specified in your request that will be used by M-Pesa to send a notification upon processing of the payment request.                                                             | URL            | <https://ip> or domain:port/path                                            |
| Occasion            | Any additional information to be associated with the transaction.                                                                                                                                    | Alpha-numeric  | Sentence of up to 100 characters                                           |

```dart
ElevatedButton(
    onPressed: () {
        FlutterMpesa.businessToCustomer(
        businessShortCode: "[BUSINESS SHORT CODE]",
        recipientPhoneNumber: "[RECEIPENT PHONE NUMBER]",
        amount: "1",
        b2cPaymentType: B2CPaymentType.salaryPayment,
        initiatorName: "[INITIATOR NAME]",
        queueTimeOutUrl: "https://mydomain.com/b2c/queue",
        resultUrl: "https://mydomain.com/b2c/result",
        remarks: "remarks",
        occassion: "occassion",
        ).then((value) => print(value));
    },
    child: const Text("BUSINESS TO CUSTOMER"),
),
```

### Transaction Status

| Name                      | Description                                                                                                                                                 | Type           | Sample Values                                                            |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|--------------------------------------------------------------------------|
| CommandID                 | Takes only the 'TransactionStatusQuery' Command ID.                                                                                                          | String         | TransactionStatusQuery                                                   |
| PartyA                    | Organization/MSISDN receiving the transaction                                                                                                                | Numeric        | Shortcode (6-9 digits) or MSISDN (12 Digits)                             |
| IdentifierType            | Type of organization receiving the transaction                                                                                                               | Numeric        | 4 – Organization shortcode                                                |
| Remarks                   | Comments that are sent along with the transaction                                                                                                            | String         | A sequence of characters up to 100                                        |
| Initiator                 | The name of the initiator initiating the request.                                                                                                           | Alpha-Numeric  | Credential/username used to authenticate the transaction request          |
| SecurityCredential        | Encrypted credential of the user getting transaction status                                                                                                  | String         | Encrypted password for the initiator to authenticate the transaction request |
| QueueTimeoutURL           | The path that stores information of timeout transaction                                                                                                      | URL            | <https://ip:port> or domain:port/path                                       |
| TransactionID             | Unique identifier to identify a transaction on Mpesa                                                                                                         | Alpha-Numeric  | LXXXXXX1234                                                              |
| ResultURL                 | The path that stores information of a transaction.                                                                                                           | URL            | <https://ip:port/path> or domain:port/path                                  |
| Occasion                  | Optional parameter                                                                                                                                          | String         | A sequence of characters up to 100                                        |
| OriginatorConversationID  | This is a global unique identifier for the transaction request returned by the API proxy upon successful request submission. If you don’t have the M-PESA transaction ID you can use this to query. | String         | AG_20190826_0000777ab7d848b9e721                                         |

```dart
  ElevatedButton(
    onPressed: () {
        FlutterMpesa.transactionStatus(
        initiator: "[INITIATOR]",
        transactionId: "[TRANSACTION ID]",
        partyA: "[PARTY Q]",
        transactionStatusIdentifierType:
            ['TransactionStatusIdentifierType'],
        queueTimeOutUrl:
            'https://mydomain.com/TransactionStatus/queue/',
        resultUrl: 'https://mydomain.com/TransactionStatus/result/',
        occassion: 'occassion',
        remarks: 'OK',
        ).then((value) => print(value));
    },
    child: const Text("TRANSACTION STATUS"),
),
```

[<span style>**READ MORE HERE**</span>](https://developer.safaricom.co.ke/Documentation)

## Contributing

Contributions are welcome! If you find any bugs or want to add new features, feel free to submit issues or pull requests.

## Acknowledgements

This package is inspired by the [<span style>**M-PESA DARAJA API**</span>](https://developer.safaricom.co.ke/) API provided by Safaricom Limited.
