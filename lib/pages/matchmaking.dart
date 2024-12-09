import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  _MatchmakingPageState createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  final TextEditingController _controller = TextEditingController();
  String? errorMessage;
  List<dynamic> players = [];
  bool isLoading = false;

  Future<void> fetchPlayers(int playerTrophy) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      players = [];
    });

    try {
      final fetchedPlayers = await fetchMatchingPlayers(playerTrophy);
      setState(() {
        players = fetchedPlayers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Widget buildPlayerList() {
    if (players.isEmpty) {
      return const Center(
        child: Text(
          'No players found.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          title: Text(player['display_name'] ?? 'N/A'),
          subtitle: Text('Trophies: ${player['trophies'] ?? 'N/A'}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matchmaking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find Players by Trophy Range',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Your Trophy Count',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final input = int.tryParse(_controller.text);
                if (input == null) {
                  setState(() {
                    errorMessage = 'Please enter a valid number.';
                  });
                  return;
                }
                fetchPlayers(input); 
              },
              child: const Text('Find Players'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (!isLoading && errorMessage == null && players.isNotEmpty)
              Expanded(
                child: buildPlayerList(), 
              ),
          ],
        ),
      ),
    );
  }
}
