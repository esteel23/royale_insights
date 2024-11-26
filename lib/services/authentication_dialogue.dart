import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthenticationDialog extends StatefulWidget {
  @override
  _AuthenticationDialogState createState() => _AuthenticationDialogState();
}

class _AuthenticationDialogState extends State<AuthenticationDialog> {
  final TextEditingController _playerTagController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();
  String _responseMessage = '';

  Future<void> _authenticatePlayer() async {
    final playerTag = _playerTagController.text.trim();
    final apiToken = _apiTokenController.text.trim();

    if (playerTag.isEmpty || apiToken.isEmpty) {
      setState(() {
        _responseMessage = 'Both fields are required.';
      });
      return;
    }

    // Call the authenticatePlayer function from api_services.dart
    final responseMessage = await authenticatePlayer(playerTag, apiToken);
    
    setState(() {
      _responseMessage = responseMessage;
    });
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
              labelText: 'Player Tag (without #)',
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
            obscureText: true,
          ),
          const SizedBox(height: 16),
          Text(
            _responseMessage,
            style: const TextStyle(color: Colors.red, fontSize: 16),
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
      ],
    );
  }
}