import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/carousel_widget.dart';
import '../widgets/item_card.dart';
import 'add_item_screen.dart';
import 'user_items_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data for the Home screen
  final List<Item> featuredItems = [
    Item(
      id: '1',
      title: 'Bicicleta Caloi Aro 29',
      description: 'Bicicleta em ótimo estado, pouco uso.',
      price: 650.0,
      imageUrl:
          'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&q=80&w=400',
      contact: '(11) 99999-9999',
    ),
    Item(
      id: '2',
      title: 'Sofá 3 Lugares',
      description: 'Sofá retrátil e reclinável.',
      price: 800.0,
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=400',
      contact: '(11) 98888-8888',
    ),
    Item(
      id: '3',
      title: 'Livros de Programação',
      description: 'Doação de livros de Java e Python.',
      price: 0.0,
      imageUrl:
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&q=80&w=400',
      contact: '(11) 97777-7777',
    ),
  ];

  final List<Item> recentItems = [
    Item(
      id: '4',
      title: 'Monitor Dell 24"',
      description: 'Monitor Full HD com ajuste de altura.',
      price: 450.0,
      imageUrl:
          'https://images.unsplash.com/photo-1527443154391-507e9dc6c5cc?auto=format&fit=crop&q=80&w=400',
      contact: '(11) 96666-6666',
    ),
    Item(
      id: '5',
      title: 'Geladeira Brastemp',
      description: 'Geladeira Frost Free branca. Gelando muito!',
      price: 1200.0,
      imageUrl:
          'https://images.unsplash.com/photo-1584568694244-14fbdf83bd30?auto=format&fit=crop&q=80&w=400',
      contact: '(11) 95555-5555',
    ),
    Item(
      id: '6',
      title: 'Roupas Infantis',
      description: 'Lote de roupas para bebê de 0 a 6 meses. Doação.',
      price: 0.0,
      imageUrl:
          'https://images.unsplash.com/photo-1522771930-78848d928718?auto=format&fit=crop&q=80&w=400',
      contact: '(11) 94444-4444',
    ),
    Item(
      id: '7',
      title: 'Mesa de Escritório',
      description: 'Mesa em L, cor madeira clara.',
      price: 200.0,
      imageUrl:
          'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?auto=format&fit=crop&q=80&w=400',
      contact: '(11) 93333-3333',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Desapega.AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Meus Anúncios',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserItemsScreen(
                    allItems: recentItems, // Usamos os itens recentes como "banco" para o usuário ver os que adicionou
                    onItemChanged: () => setState(() {}),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Destaques',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            CarouselWidget(items: featuredItems.where((item) => item.isActive).toList()),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Adicionados Recentemente',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final activeRecentItems = recentItems.where((item) => item.isActive).toList();
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeRecentItems.length,
                  itemBuilder: (context, index) {
                    return ItemCard(item: activeRecentItems[index]);
                  },
                );
              }
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push<Item>(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );
          if (newItem != null) {
            setState(() {
              recentItems.insert(0, newItem);
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item adicionado com sucesso!')),
              );
            }
          }
        },
        tooltip: 'Cadastrar Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
