import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayerDetailPage extends StatefulWidget {
  final Map<String, dynamic> player;

  const PlayerDetailPage({super.key, required this.player});

  @override
  _PlayerDetailPageState createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  Map<String, dynamic>? _playerDetails;
  List<dynamic> _cardSlots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlayerDetails();
  }

  Future<void> _fetchPlayerDetails() async {
    String playerId = widget.player['id'];
    
    // Remove the first character if it's '#'
    if (playerId.startsWith('#')) {
      playerId = playerId.substring(1);
    }

    final response = await http.get(Uri.parse('http://34.162.121.53:3000/api/player_decks/$playerId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _playerDetails = data['player'];
        _cardSlots = data['cardSlots'];
        _isLoading = false;
      });
    } else {
      print('Error fetching player details');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_playerDetails == null) {
      return const Scaffold(
        body: Center(child: Text('Player details not found')),
      );
    }

    // Extract player details
    final String playerName = _playerDetails?['username'] ?? 'Unknown';
    final String playerTag = _playerDetails?['id']?.toString() ?? 'N/A';
    final String clanTag = _playerDetails?['clanid']?.toString() ?? 'N/A';
    final String rank = widget.player['rank']?.toString() ?? 'N/A';  // Access rank from player map
    final String trophies = _playerDetails?['score']?.toString() ?? 'N/A';
    final String level = 'Placeholder Level'; // Placeholder for missing data
    final String clanRank = _playerDetails?['role'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(playerName),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.zero, 
          child:  Text('Tag: $playerTag | Clan Tag: $clanTag'),
      ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player Stats
            Text('Rank: $rank', style: const TextStyle(fontSize: 18)), // Display rank
            const SizedBox(height: 8),
            Text('Trophies: $trophies', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Level: $level', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Clan Rank: $clanRank', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            
            // Card Slots Grid
            const Text('Card Slots', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _cardSlots.length,
                itemBuilder: (context, index) {
                  final cardSlot = _cardSlots[index];
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.blue[100],
                    child: Center(
                      child: Text(
                        'Slot ${cardSlot['slot']}: Card ID ${cardSlot['cardid']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
