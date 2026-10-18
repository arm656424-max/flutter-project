import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/quest_store.dart';
import '../models/shop_item.dart';
import '../theme/app_theme.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  Color _getRarityColor(ItemType type) {
    switch (type) {
      case ItemType.expPotion:
        return SoloTheme.rare;
      case ItemType.weapon:
        return SoloTheme.epic;
      case ItemType.armor:
        return SoloTheme.legendary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuestStore>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: SoloTheme.background,
        appBar: const TabBar(
          indicatorColor: SoloTheme.neonBlue,
          indicatorWeight: 3,
          labelColor: SoloTheme.neonBlue,
          unselectedLabelColor: SoloTheme.textMuted,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
          tabs: [
            Tab(text: 'SYSTEM SHOP'),
            Tab(text: 'INVENTORY'),
          ],
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: store.availableShopItems.length,
              itemBuilder: (context, index) {
                final item = store.availableShopItems[index];
                final rarityColor = _getRarityColor(item.type);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: SoloTheme.systemBoxDecoration(borderColor: rarityColor),
                  child: ListTile(
                    title: Text(item.name.toUpperCase(), style: TextStyle(color: rarityColor, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    subtitle: Text('${item.description}\nPRICE: ${item.price} GOLD', style: const TextStyle(color: SoloTheme.textMuted, fontSize: 11)),
                    trailing: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: rarityColor),
                        shape: const BeveledRectangleBorder(),
                      ),
                      onPressed: store.profile.gold >= item.price ? () => store.buyItem(item) : null,
                      child: Text('PURCHASE', style: TextStyle(color: rarityColor, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                );
              },
            ),
            store.inventory.isEmpty
                ? const Center(child: Text('[ INVENTORY IS EMPTY ]', style: TextStyle(color: SoloTheme.textMuted, letterSpacing: 2)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: store.inventory.length,
                    itemBuilder: (context, index) {
                      final item = store.inventory[index];
                      final rarityColor = _getRarityColor(item.type);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: SoloTheme.systemBoxDecoration(borderColor: rarityColor),
                        child: ListTile(
                          title: Text(item.name.toUpperCase(), style: const TextStyle(color: SoloTheme.textBright, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          subtitle: Text(item.description, style: const TextStyle(color: SoloTheme.textMuted, fontSize: 11)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: SoloTheme.neonBlue, shape: const BeveledRectangleBorder()),
                            onPressed: () => store.useItem(item),
                            child: const Text('EQUIP / USE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}