import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AzureService {
  // Azure Function URL
  static const String _azureFuncUrl =
      "https://book-summary-func.azurewebsites.net/api/fetch_summary?code=OsE9un3KB2sicSJmv-zrscZ4_bvoxSdZoJqUwmw0UdvxAzFuMZR-FA%3D%3D";

  Future<String> getSummary({String bookTitle = "zero to one"}) async {
    final url = Uri.parse(_azureFuncUrl);

    // Prepare the body as a map and encode it into JSON format
    final body = json.encode({
      'book_title': bookTitle,
    });

    try {
      // Send the POST request with the body and headers
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // If the request was successful, print the response
        if (kDebugMode) {
          print('Response: ${response.body}');
        }
        return response.body;
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
        return 'Summary not found';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return '';
    }
  }
}
