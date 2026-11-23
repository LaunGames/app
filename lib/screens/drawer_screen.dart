import 'package:flutter/material.dart';
import '../main.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(child: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [
        const CircleAvatar(radius: 24, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Juanita Nguyen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text('juanita@mail.com', style: TextStyle(color: Colors.grey, fontSize: 11)),
        ])),
        IconButton(icon: const Icon(Icons.logout, size: 20), onPressed: () {}),
      ]),
      const SizedBox(height: 24), const Divider(),
      ListTile(contentPadding: EdgeInsets.zero, title: const Text('Все меню'), onTap: () => Navigator.pop(context)),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Заказы'),
        trailing: AnimatedBuilder(
          animation: ordersState,
          builder: (context, _) {
            if (ordersState.orders.isEmpty) return const SizedBox();
            return Text('${ordersState.orders.length}', style: const TextStyle(color: Colors.grey));
          },
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
        },
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Корзина'),
        trailing: AnimatedBuilder(
          animation: cart,
          builder: (context, _) {
            if (cart.totalItems == 0) return const SizedBox();
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: kYellow, shape: BoxShape.circle),
              child: Text('${cart.totalItems}', style: const TextStyle(fontSize: 10)),
            );
          },
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
        },
      ),
    ])));
  }
}