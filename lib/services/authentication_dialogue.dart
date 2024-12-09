import 'package:flutter/material.dart';
import 'api_service.dart';
import '../pages/profile.dart';

class AuthenticationDialog extends StatefulWidget {
  @override
  _AuthenticationDialogState createState() => _AuthenticationDialogState();
}

class _AuthenticationDialogState extends State<AuthenticationDialog> {
  final TextEditingController _playerTagController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();
  String _responseMessage = '';
  bool _isAuthenticated = false;
  List<Map<String, dynamic>> _battleLog = []; // Updated to store a list

  Future<void> _authenticatePlayer() async {
    final playerTag = _playerTagController.text.trim();
    final apiToken = _apiTokenController.text.trim();

    if (playerTag.isEmpty || apiToken.isEmpty) {
      setState(() {
        _responseMessage = 'Player Tag and API Token are required.';
      });
      return;
    }

    try {
      final result = await addPlayer(playerTag, apiToken); // Call the API service
      if (result.contains('successfully added')) {
        // Fetch the battle log after authentication
        final battleLogData = await fetchBattleLog(playerTag);

        if (battleLogData is! List) {
          throw Exception('Invalid battle log format.');
        }

        setState(() {
          _responseMessage = result; // Update response message
          _isAuthenticated = true;
          _battleLog = List<Map<String, dynamic>>.from(battleLogData); // Store battle log data
        });
      } else {
        setState(() {
          _responseMessage = result; // Display the error message
          _isAuthenticated = false;
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Authentication failed: $e';
        _isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Clash Royale Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _playerTagController,
            decoration: const InputDecoration(
              labelText: 'Player Tag',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _apiTokenController,
            decoration: const InputDecoration(
              labelText: 'API Token',
              border: OutlineInputBorder(),
            ),
            obscureText: true, // Hide API token input for security
          ),
          const SizedBox(height: 16),
          Text(
            _responseMessage,
            style: TextStyle(
              color: _isAuthenticated ? Colors.green : Colors.red,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _authenticatePlayer,
          child: const Text('Login'),
        ),
        if (_isAuthenticated)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    playerTag: _playerTagController.text.trim(),
                    playerRowData: _battleLog, // Pass the battle log data
                  ),
                ),
              );
            },
            child: const Text('Profile'),
          ),
      ],
    );
  }
}
