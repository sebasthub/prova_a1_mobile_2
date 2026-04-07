class Item {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String contact;
  bool isActive;
  final bool isMine;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.contact,
    this.isActive = true,
    this.isMine = false,
  });
}
