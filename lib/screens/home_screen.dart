import 'package:flutter/material.dart';
import '../models/item.dart';
import '../helpers/db_helper.dart';
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
  List<Item> allItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final dbHelper = DbHelper();
    final items = await dbHelper.getItems();
    // Sort items by id ascending if assuming id is numeric/timestamp 
    // or just visually sorting them backwards (recent first).
    // The items from mock are IDs 1-7, new will be timestamp string. We'll just reverse to show latest.
    setState(() {
      allItems = items.reversed.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final activeItems = allItems.where((item) => item.isActive).toList();
    final featuredItems = activeItems.take(4).toList();

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
                    allItems: allItems,
                    onItemChanged: () {
                      _loadItems();
                    },
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
            if (featuredItems.isNotEmpty)
              CarouselWidget(items: featuredItems)
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Nenhum destaque no momento.'),
              ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Todos os Anúncios',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                if (activeItems.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Nenhum anúncio ativo.'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeItems.length,
                  itemBuilder: (context, index) {
                    return ItemCard(item: activeItems[index]);
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
            await DbHelper().insertItem(newItem);
            await _loadItems();
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
