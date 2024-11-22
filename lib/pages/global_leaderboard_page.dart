import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'player_detail_page.dart';

class GlobalLeaderboardPage extends StatefulWidget {
  const GlobalLeaderboardPage({super.key});

  @override
  _GlobalLeaderboardPageState createState() => _GlobalLeaderboardPageState();
}

class _GlobalLeaderboardPageState extends State<GlobalLeaderboardPage> {
  List<dynamic> _leaderboard = [];
  List<dynamic> _filteredLeaderboard = [];
  String _searchQuery = '';
  String _searchCategory = 'Player Tag';
  String _numberFilterType = 'Equal';

  final List<String> _categories = [
    'Rank',
    'Player Tag',
    'Display Name',
    'Trophies',
    'Clan Rank',
    'Clan Tag'
  ];

  final List<String> _numberFilterOptions = ['Greater than', 'Less than', 'Equal'];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final data = await ApiService.fetchLeaderboard();
      setState(() {
        _leaderboard = List.generate(data.length, (index) {
          return {
            'rank': index + 1, // Add rank to each player map
            ...Map<String, dynamic>.from(data[index]),
          };
        });
        _filteredLeaderboard = _leaderboard;
      });
    } catch (e) {
      print('Error fetching leaderboard: $e');
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredLeaderboard = _leaderboard.where((player) {
        final value = player[_getKeyForCategory(_searchCategory)];
        if (value == null) return false;

        if ((_searchCategory == 'Trophies' || _searchCategory == 'Rank') && int.tryParse(query) != null) {
          int queryNumber = int.parse(query);
          int playerNumber = value is int ? value : int.tryParse(value.toString()) ?? 0;
          if (_numberFilterType == 'Greater than') return playerNumber > queryNumber;
          if (_numberFilterType == 'Less than') return playerNumber < queryNumber;
          return playerNumber == queryNumber;
        } else {
          return value.toString().toLowerCase().contains(query.toLowerCase());
        }
      }).toList();
    });
  }

  String _getKeyForCategory(String category) {
    switch (category) {
      case 'Rank':
        return 'rank';
      case 'Display Name':
        return 'username';
      case 'Trophies':
        return 'score';
      case 'Clan Rank':
        return 'role';
      case 'Clan Tag':
        return 'clanid';
      default:
        return 'id';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blueAccent,
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Global Leaderboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _searchCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _searchCategory = value!;
                      _searchQuery = '';
                      _filteredLeaderboard = _leaderboard;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search by',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (_searchCategory == 'Trophies' || _searchCategory == 'Rank')
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _numberFilterType,
                    items: _numberFilterOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _numberFilterType = value!;
                        _updateSearchQuery(_searchQuery);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Filter Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _updateSearchQuery,
                  keyboardType: (_searchCategory == 'Trophies' || _searchCategory == 'Rank')
                      ? TextInputType.number
                      : TextInputType.text,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Text('Rank', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Player Tag', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Display Name', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Trophies', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Clan Rank', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Clan Tag', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        Expanded(
          child: _filteredLeaderboard.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _filteredLeaderboard.length,
                  itemBuilder: (context, index) {
                    final player = _filteredLeaderboard[index];
                    final backgroundColor = index.isEven ? Colors.white : Colors.grey[200];
                    Color hoverColor = Colors.blue.withOpacity(0.1);
                    bool isHovered = false;

                    return StatefulBuilder(
                      builder: (context, setHoverState) {
                        return MouseRegion(
                          onEnter: (_) {
                            setHoverState(() => isHovered = true);
                          },
                          onExit: (_) {
                            setHoverState(() => isHovered = false);
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayerDetailPage(player: player),
                                ),
                              );
                            },
                            child: Container(
                              color: isHovered ? hoverColor : backgroundColor,
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(child: Text(player['rank']?.toString() ?? 'N/A')),
                                  Expanded(child: Text(player['id']?.toString() ?? 'N/A')),
                                  Expanded(child: Text(player['username'] ?? 'Unknown')),
                                  Expanded(child: Text(player['score']?.toString() ?? 'N/A')),
                                  Expanded(child: Text(player['role'] ?? 'N/A')),
                                  Expanded(child: Text(player['clanid']?.toString() ?? 'N/A')),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
