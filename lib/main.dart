import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  await Hive.openBox('users');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Toko E-Commerce',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (context) {
            
            final auth = Provider.of<AuthProvider>(context);
            if (auth.username != null) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          }
        },
        initialRoute: '/',
      ),
    );
  }
}