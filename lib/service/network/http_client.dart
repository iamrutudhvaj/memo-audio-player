import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CustomHttpClient {
  static final CustomHttpClient _instance =
      CustomHttpClient._internal(); // Private instance

  factory CustomHttpClient() {
    return _instance; // Always returns the same instance
  }

  http.Client _client;

  // Private constructor
  CustomHttpClient._internal() : _client = http.Client();

  // GET request with error handling and timeout
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _client
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw const HttpException('Request timed out');
    } on SocketException {
      throw const HttpException('No Internet connection');
    } on Exception catch (e) {
      throw HttpException('An error occurred: $e');
    }
  }

  // POST request with error handling and timeout
  Future<dynamic> post(String url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      final response = await _client
          .post(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw const HttpException('Request timed out');
    } on SocketException {
      throw const HttpException('No Internet connection');
    } on Exception catch (e) {
      throw HttpException('An error occurred: $e');
    }
  }

  // Download file and return the local path where it's saved
  Future<String> downloadFile(String encodedUrl) async {
    try {
      String url = Uri.decodeFull(encodedUrl);
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Get the directory to store the file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${url.split('/').last}';
        final file = File(filePath);

        // Write the bytes to the file
        await file.writeAsBytes(response.bodyBytes);

        log("File downloaded successfully to $filePath");
        return filePath; // Return the file path
      } else {
        throw HttpException(
            'Failed to download file, Status Code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw const HttpException('Download request timed out');
    } on SocketException {
      throw const HttpException('No Internet connection');
    } on Exception catch (e) {
      throw HttpException('An error occurred while downloading the file: $e');
    }
  }

  // Helper function to handle responses and errors
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw HttpException('Failed to parse response: $e');
      }
    } else {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }
  }

  // Close the client when done
  void close() {
    _client.close();
  }
}
