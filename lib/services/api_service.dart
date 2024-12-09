import 'dart:math';

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

Future<List<Map<String, dynamic>>> fetchClanMembers(String clanTag) async {
  try {
    // Properly encode the clanTag to handle special characters like #
    final encodedClanTag = Uri.encodeComponent(clanTag);

    // Construct the API URL with the encoded clanTag
    final uri = Uri.parse('$_baseUrl/clanmembers?clanTag=$encodedClanTag');

    // Make an HTTP GET request to the server
    final response = await http.get(uri);

    // Check if the response status code is OK (200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> jsonData = json.decode(response.body);

      // Convert each row to a Map<String, dynamic> and return the list
      return jsonData.map((row) => Map<String, dynamic>.from(row)).toList();
    } else {
      // Throw an exception for server errors
      throw Exception('Failed to fetch clan members: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors during the HTTP request or JSON parsing
    throw Exception('Error fetching clan members: $e');
  }
}

Future<List<Map<String, dynamic>>> fetchPlayerCards(String playerTag) async {
  try {
    final encodedPlayerTag = Uri.encodeComponent(playerTag);

    // Corrected query parameter: "playerTag" instead of "=playertag"
    final uri = Uri.parse('$_baseUrl/getplayercards?playerTag=$encodedPlayerTag');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((row) => Map<String, dynamic>.from(row)).toList();
    } else {
      throw Exception('Failed to fetch player cards: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching player cards: $e');
  }
}

Future<Map<String, dynamic>> fetchCardInfo(int cardId) async {
  // Replace with your server URL
  const String baseUrl = '$_baseUrl/cardInfo';

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cardId': cardId}),
    );

    if (response.statusCode == 200) {
      // Successfully fetched card info
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      // Card not found
      throw Exception('Card not found');
    } else {
      // Handle other errors
      throw Exception('Failed to fetch card info: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions
    throw Exception('Error fetching card info: $e');
  }
}


Future<String> addPlayer(String playerTag, String apiToken) async {
  final url = Uri.parse('$_baseUrl/addPlayer'); 

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'playerTag': playerTag, 'apiToken': apiToken}),
    );
  
    if (response.statusCode == 200) {
      // Player successfully added with tracked data
      final responseBody = jsonDecode(response.body);
      return responseBody['message'] ??
          'Player successfully added to the database.';
    } else if (response.statusCode == 404) {
      // Player not found in Clash Royale API or no tracked data exists
      final responseBody = jsonDecode(response.body);
      final error = responseBody['error'] ??
          responseBody['message'] ??
          'Player not found.';
      return 'Error: $error';
    } else {
      // Handle other errors
      final responseBody = jsonDecode(response.body);
      final error = responseBody['error'] ?? 'Unknown error occurred.';
      return 'Error: $error';
    }
  } catch (e) {
    // Handle network errors
    return 'Failed to connect to the server: $e';
  }
}


Future<List<Map<String, dynamic>>> fetchBattleLog(String playerTag) async {
  // Properly encode the playerTag to handle special characters
  final encodedPlayerTag = Uri.encodeComponent(playerTag);
  final url = Uri.parse('$_baseUrl/getPlayersBattlelog?playerTag=$encodedPlayerTag');

  try {
    // Make the GET request to the API
    final response = await http.get(url);

    // Check if the request was successful
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Convert the dynamic list to a list of maps
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to fetch battle log. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Provide a descriptive error message for debugging
    throw Exception('Error fetching battle log: $e');
  }
}


Future<Map<String, dynamic>> fetchPlayerData(String playerTag) async {

  final encodedPlayerTag = Uri.encodeComponent(playerTag);
  final url = Uri.parse('$_baseUrl/getPlayer/?playerTag=$encodedPlayerTag');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch player data.');
    }
  } catch (e) {
    throw Exception('Error fetching player data: $e');
  }
}

Future<List<dynamic>> fetchMatchingPlayers(int playerTrophy) async {

  final response = await http.post(

    Uri.parse('$_baseUrl/matchmaking'), // Replace with your server URL
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'playerTrophy': playerTrophy,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception('Failed to load matching players: ${response.statusCode}');
  }
}