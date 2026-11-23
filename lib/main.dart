import 'package:flutter/material.dart';
import 'cart_state.dart';
import 'orders_state.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

const Color kYellow = Color(0xFFF2C94C);

final CartState cart = CartState();
final OrdersState ordersState = OrdersState();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white, primaryColor: kYellow, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}