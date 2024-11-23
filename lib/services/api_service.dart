import 'package:http/http.dart' as http;
import 'dart:convert';

const String _baseUrl = 'http://34.162.121.53:3000/api';

/// Fetches data from the given SQL server endpoint and processes it into a list.
///
/// [queryParam] is the endpoint of the SQL server API that returns JSON data.
///
/// Returns a list of maps where each map represents a row in the SQL table.
Future<List<Map<String, dynamic>>> fetchLeaderboard(String queryParam) async {
  try {
    // Make an HTTP GET request to the server
    final response = await http.get(Uri.parse('$_baseUrl/$queryParam'));

    // Check if the response status code is OK
    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> jsonData = json.decode(response.body);

      // Convert each row to a map (assuming each row is a JSON object)
      return jsonData.map((row) => Map<String, dynamic>.from(row)).toList();
    } else {
      // Handle server errors
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors during the HTTP request or JSON parsing
    throw Exception('Error fetching JSON data: $e');
  }
}


Future<String> authenticatePlayer(String playerTag, String apiToken) async {
  try {
    final response = await http.post(Uri.parse('$_baseUrl/authenticatePlayer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'playerTag': playerTag,
        'apiToken': apiToken,
      }),
    );

    if (response.statusCode == 200) {
      return 'Login successful';
    } else if (response.statusCode == 403) {
      return 'Invalid player tag or API token';
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return 'An error occurred. Please try again.';
    }
  } catch (error) {
    print('Request failed with error: $error');
    return 'An error occurred. Please check your connection.';
  }
}

