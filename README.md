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
dart pub add flutter_mpesa_package
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

FlutterMpesa.initFlutterMpesa(
    consumerKey: "",
    consumerSecret: "",
    securityCredential: "",
  );
  runApp(const MyApp());
}
```

**NOTE : YOU DON'T HAVE TO CALL THIS METHOD EVERY TIME YOU USE OTHER METHODS, I ALREADY DID THAT FOR INDIVIDUAL METHODS.**

[<span style>**Read More**</span>](https://developer.safaricom.co.ke/Documentation)

## Contributing

Contributions are welcome! If you find any bugs or want to add new features, feel free to submit issues or pull requests.

## Acknowledgements

This package is inspired by the [<span style>**M-PESA DARAJA API**</span>](https://developer.safaricom.co.ke/) API provided by Safaricom Limited.
