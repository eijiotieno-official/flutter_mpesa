import 'dart:convert';
import 'package:http/http.dart' as http;

// This function performs a GET request and returns a Future containing a Map<String, dynamic>.
Future<Map<String, dynamic>> getRequest({
  required String url, // The URL for the GET request.
  required Map<String, String>
      headers, // Headers to be included in the request.
}) async {
  try {
    // Make the HTTP GET request using the http package.
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    // Check if the response status code is 200 (OK).
    if (response.statusCode == 200) {
      // If successful, decode the JSON response and return the data.
      return json.decode(response.body);
    } else {
      // If not successful, throw an exception with an informative error message.
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    // Handle and throw an exception for any unexpected errors during the HTTP request.
    throw Exception('Error during HTTP request: $error');
  }
}
