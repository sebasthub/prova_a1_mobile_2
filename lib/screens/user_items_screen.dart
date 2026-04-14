import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/user_item_card.dart';

class UserItemsScreen extends StatefulWidget {
  final List<Item> allItems;
  final VoidCallback onItemChanged;

  const UserItemsScreen({
    super.key,
    required this.allItems,
    required this.onItemChanged,
  });

  @override
  State<UserItemsScreen> createState() => _UserItemsScreenState();
}

class _UserItemsScreenState extends State<UserItemsScreen> {
  @override
  Widget build(BuildContext context) {
    // Filtra apenas os itens criados pelo usuário
    final myItems = widget.allItems.where((item) => item.isMine).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Anúncios'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: myItems.isEmpty
          ? const Center(
              child: Text(
                'Você ainda não possui anúncios cadastrados.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: myItems.length,
              itemBuilder: (context, index) {
                final item = myItems[index];
                return UserItemCard(
                  item: item,
                  onItemChanged: () {
                    setState(() {});
                    widget.onItemChanged();
                  },
                );
              },
            ),
    );
  }
}
