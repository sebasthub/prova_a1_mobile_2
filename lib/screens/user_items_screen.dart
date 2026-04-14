import 'package:flutter/material.dart';
import '../models/item.dart';
import '../helpers/db_helper.dart';

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
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: item.isActive
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                        color: item.isActive ? null : Colors.grey,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.price == 0
                            ? 'Grátis'
                            : 'R\$ ${item.price.toStringAsFixed(2)}'),
                        const SizedBox(height: 4),
                        Text(
                          item.isActive ? 'Status: Ativo' : 'Status: Inativo',
                          style: TextStyle(
                            color: item.isActive ? Colors.teal : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Switch(
                      value: item.isActive,
                      activeColor: Colors.teal,
                      onChanged: (value) async {
                        setState(() {
                          item.isActive = value;
                        });
                        await DbHelper().updateItem(item);
                        widget.onItemChanged(); // Notifica a home para atualizar a lista
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
