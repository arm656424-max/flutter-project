enum ItemType { expPotion, weapon, armor }

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final ItemType type;
  final int boostValue;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.boostValue,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'type': type.index,
        'boostValue': boostValue,
      };

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Item',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      type: json['type'] != null
          ? ItemType.values[(json['type'] as num).toInt() % ItemType.values.length]
          : ItemType.expPotion,
      boostValue: (json['boostValue'] as num?)?.toInt() ?? 0,
    );
  }
}