import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'http://34.162.121.53:3000/api';

  static Future<List<dynamic>> fetchLeaderboard() async {
    final response = await http.get(Uri.parse('$_baseUrl/leaderboard'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }
}

Future<String> authenticatePlayer(String playerTag, String apiToken) async {
  try {
    final response = await http.post(
      Uri.parse('http://34.162.121.53:3000/api/authenticatePlayer'),
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

Future<List<dynamic>> fetchClanLeaderboard() async {
  final response = await http.get(Uri.parse('http://34.162.121.53:3000/api/clanLeaderboard'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load clan leaderboard');
  }
}

Future<List<dynamic>> fetchClanMembers(String clanId) async {
  final response = await http.get(Uri.parse('http://34.162.121.53:3000/api/clan/$clanId/players'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load clan members');
  }
}
