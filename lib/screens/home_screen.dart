import 'package:flutter/material.dart';
import '../main.dart';
import '../cart_state.dart';
import 'drawer_screen.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Все';
  String searchQuery = '';
  String selectedCity = 'Челябинск';

  final List<Map<String, String>> allFoods = [
    {
      'title': 'Дерзкая Марго',
      'price': '300',
      'category': 'Пицца',
      'desc': 'Пицца с томатным соусом, моцареллой, пепперони и свежим базиликом. Острая и ароматная.',
      'image': 'assets/images/pizza.jpg',
    },
    {
      'title': 'Горячий парень',
      'price': '300',
      'category': 'Кебаб',
      'desc': 'Сочный кебаб из говядины с луком и специями, подаётся с лавашом и соусом.',
      'image': 'assets/images/kebab.jpg',
    },
    {
      'title': 'Вкусняшка Миа',
      'price': '300',
      'category': 'Десерт',
      'desc': 'Ассорти из свежей клубники, печенья, джема и зелени. Идеально для лёгкого перекуса или чаепития.',
      'image': 'assets/images/burger.jpg',
    },
    {
      'title': 'Сытный Питт',
      'price': '300',
      'category': 'Бургер',
      'desc': 'Двойной бургер с говядиной, беконом, картофелем фри и сырным соусом.',
      'image': 'assets/images/pitt.jpg',
    },
  ];

  List<Map<String, String>> get filteredFoods {
    return allFoods.where((food) {
      final matchesCategory = selectedCategory == 'Все' || food['category'] == selectedCategory;
      final matchesSearch = food['title']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showCityPicker() {
    final cities = ['Челябинск', 'Москва', 'Санкт-Петербург', 'Екатеринбург', 'Казань'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Выберите город', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...cities.map((city) => ListTile(
                title: Text(city),
                trailing: city == selectedCity ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  setState(() => selectedCity = city);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu, color: Colors.black), onPressed: () => Scaffold.of(c).openDrawer())),
        title: GestureDetector(
          onTap: _showCityPicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selectedCity, style: const TextStyle(color: Colors.black, fontSize: 16)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ],
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: cart,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 6, top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: kYellow, shape: BoxShape.circle),
                        child: Text('${cart.totalItems}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Голоден?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Поиск по меню',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _cat(Icons.restaurant, 'Все'),
                const SizedBox(width: 16),
                _cat(Icons.local_pizza, 'Пицца'),
                const SizedBox(width: 16),
                _cat(Icons.kebab_dining, 'Кебаб'),
                const SizedBox(width: 16),
                _cat(Icons.lunch_dining, 'Бургер'),
                const SizedBox(width: 16),
                _cat(Icons.icecream, 'Десерт'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (filteredFoods.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Ничего не найдено', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ))
          else
            ...filteredFoods.map((food) => _card(
              context,
              food['title']!,
              food['price']!,
              food['desc']!,
              food['image']!,
            )),
        ],
      ),
    );
  }

  Widget _cat(IconData icon, String label) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? kYellow : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.black : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String title, String price, String desc, String image) => GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(
      title: title, price: price, desc: desc, image: image,
    ))),
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.asset(
          image,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 120,
            color: Colors.grey[300],
            child: const Icon(Icons.fastfood, size: 60, color: Colors.grey),
          ),
        ),
        Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('\$$price', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.star, size: 14, color: kYellow), const Text(' 4.5', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 8), Text('(100+) 25-30 мин', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              cart.addItem(title, price);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title добавлен в корзину')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: kYellow, foregroundColor: Colors.black, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Купить'),
          )),
        ])),
      ]),
    ),
  );
}