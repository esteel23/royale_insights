import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CardDetailsPage extends StatefulWidget {
  final int cardId;

  const CardDetailsPage({required this.cardId, super.key});

  @override
  _CardDetailsPageState createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  Map<String, dynamic>? cardInfo;
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCard();
  }

  Future<void> fetchCard() async {
    try {
      final fetchedCard = await fetchCardInfo(widget.cardId);
      setState(() {
        cardInfo = fetchedCard;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget buildCardDetails() {
    if (cardInfo == null) {
      return const Text(
        'No card details available.',
        style: TextStyle(fontSize: 18),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon on the left
        const SizedBox(width: 16),
        // Card details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Subtitle
              Text(
                cardInfo?['name'] ?? 'N/A',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                'Arena: ${cardInfo?['arena'] ?? 'N/A'} | Elixir: ${cardInfo?['elixir'] ?? 'N/A'}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Remaining Attributes
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  attributeTile('Rarity', cardInfo?['rarity']),
                  attributeTile('Type', cardInfo?['type']),
                  attributeTile('Target', cardInfo?['target']),
                  attributeTile('Speed', cardInfo?['speed']),
                  attributeTile('Hit Speed', cardInfo?['hitspeed']),
                  attributeTile('Melee Range', cardInfo?['melee_range']),
                  attributeTile('Spawn', cardInfo?['spawn']),
                  attributeTile('Lifetime', cardInfo?['lifetime']),
                  attributeTile('Target 2', cardInfo?['target_2']),
                  attributeTile('Radius', cardInfo?['radius']),
                  attributeTile('Distance Range', cardInfo?['distance_range']),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget attributeTile(String label, dynamic value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value?.toString() ?? 'N/A'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  )
                : buildCardDetails(),
      ),
    );
  }
}
