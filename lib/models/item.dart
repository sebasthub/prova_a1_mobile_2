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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'contact': contact,
      'isActive': isActive ? 1 : 0,
      'isMine': isMine ? 1 : 0,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      contact: map['contact'],
      isActive: map['isActive'] == 1,
      isMine: map['isMine'] == 1,
    );
  }
}
