// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hafiyyat/screens/home_screen.dart';
import 'package:hafiyyat/screens/splash_screen.dart';
import 'package:hafiyyat/theme/app_theme.dart';
import 'package:media_store_plus/media_store_plus.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set MediaStore app folder before initialization
    MediaStore.appFolder = "Hafiyyat";
    
    print('MediaStore başlatılıyor...');
    await MediaStore.ensureInitialized();
    print('MediaStore başarıyla başlatıldı');
  } catch (e) {
    print('MediaStore başlatma hatası: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hafiyyat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF64FFDA)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}