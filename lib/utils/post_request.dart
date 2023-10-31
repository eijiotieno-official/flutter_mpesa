import 'dart:convert';
import 'package:http/http.dart' as http;

// This function performs a POST request and returns a Future containing a Map<String, dynamic>.
Future<Map<String, dynamic>> postRequest({
  required String url, // The URL for the POST request.
  required Map<String, String>
      headers, // Headers to be included in the request.
  required Map<String, dynamic> body, // The request body to be encoded as JSON.
}) async {
  try {
    // Make the HTTP POST request using the http package.
    http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    // Check if the response status code is 200 (OK).
    if (response.statusCode == 200) {
      // If successful, decode the JSON response and return the data.
      return json.decode(response.body);
    } else {
      // If not successful, throw an exception with an informative error message.
      Map body = json.decode(response.body);
      throw Exception(body['errorMessage']);
    }
  } catch (error) {
    // Handle and throw an exception for any unexpected errors during the HTTP request.
    throw Exception('Error during HTTP request: $error');
  }
}
