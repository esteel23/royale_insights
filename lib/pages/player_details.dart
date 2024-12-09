import 'package:flutter/material.dart';
import 'card_details.dart'; // Import the card details page
import '../services/api_service.dart'; // API service to fetch player cards

class PlayerDetailsPage extends StatelessWidget {
  final String playerTag;
  final String displayName;
  final Map<String, dynamic> row; // Player's full row data

  const PlayerDetailsPage({
    required this.playerTag,
    required this.displayName,
    required this.row,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$displayName Details'),
      ),
      body: Column(
        children: [
          // Player Information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Player Tag: $playerTag',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Display Name: $displayName', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Trophies: ${row['trophies']}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Clan: ${row['clan_name'] ?? 'No Clan'}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Exp Level: ${row['exp']}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // FutureBuilder for Player's Cards
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchPlayerCards(playerTag), // Fetch player cards from API
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No cards found.'));
                } else {
                  final cards = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardDetailsPage(cardId: card['cardid']), // Pass card ID to CardDetailsPage
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            const SizedBox(height: 8),
                            Text(
                              card['name'] ?? 'Unknown Card',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
