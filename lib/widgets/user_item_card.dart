import 'package:flutter/material.dart';
import '../models/item.dart';
import '../helpers/db_helper.dart';

class UserItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onItemChanged;

  const UserItemCard({
    super.key,
    required this.item,
    required this.onItemChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            decoration:
                item.isActive ? TextDecoration.none : TextDecoration.lineThrough,
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
            item.isActive = value;
            await DbHelper().updateItem(item);
            onItemChanged();
          },
        ),
      ),
    );
  }
}
