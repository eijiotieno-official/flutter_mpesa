// Constants defining base URLs for the Safaricom API in sandbox and live environments.
const String sandboxBaseUrl = 'https://sandbox.safaricom.co.ke/';
const String liveBaseUrl = 'https://api.safaricom.co.ke/';

// This function constructs the complete URL based on the environment and endpoint.
String getUrl({required bool isLive, required String endPoint}) =>
    isLive ? '$liveBaseUrl/$endPoint' : '$sandboxBaseUrl/$endPoint';
