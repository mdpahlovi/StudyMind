import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('My Decks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _DeckCard(title: 'Deck ${index + 1}', cardCount: (index + 1) * 10, progress: (index + 1) * 0.25);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}

class _DeckCard extends StatelessWidget {
  final String title;
  final int cardCount;
  final double progress;

  const _DeckCard({required this.title, required this.cardCount, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Text('$cardCount cards', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const Spacer(),
              LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200]),
              const SizedBox(height: 8),
              Text('${(progress * 100).toInt()}% Complete', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}
