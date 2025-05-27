// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hafiyyat/screens/encode_screen.dart';
import 'package:hafiyyat/screens/decode_screen.dart';
import 'package:hafiyyat/screens/settings_screen.dart';
import 'package:hafiyyat/widgets/feature_card.dart';
import 'package:hafiyyat/widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Siber güvenlik renk teması
  static const Color _backgroundColor = Color(0xFF0A192F); // Koyu lacivert
  static const Color _accentColor = Color(0xFF64FFDA); // Siber yeşili
  static const Color _surfaceColor = Color(0xFF112240); // Orta lacivert
  static const Color _textColor = Color(0xFFCCD6F6); // Açık gri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: const CustomAppBar(title: 'HAFIYYAT'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '{ ',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'HAFİYYAT',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                      ),
                    ),
                    TextSpan(
                      text: ' }',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: _accentColor,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GİZLİLİK PROTOKOLÜ v1.0',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gizliliğin Gizlendiği Yer.',
                      style: TextStyle(
                        fontSize: 22,
                        color: _textColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '01001110 01001111 01010111',
                      style: TextStyle(
                        fontSize: 12,
                        color: _accentColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    FeatureCard(
                      title: 'Görüntü Gizle',
                      description: 'Gri görüntüyü renkli fotoğrafa gizle',
                      icon: Icons.enhanced_encryption,
                      backgroundColor: _surfaceColor,
                      iconColor: _accentColor,
                      textColor: _textColor,
                      borderColor: _accentColor.withOpacity(0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EncodeScreen(),
                          ),
                        );
                      },
                    ),
                    FeatureCard(
                      title: 'Görüntü Çıkar',
                      description: 'Renkli fotoğraftan gri görüntüyü çıkar',
                      icon: Icons.no_encryption,
                      backgroundColor: _surfaceColor,
                      iconColor: _accentColor,
                      textColor: _textColor,
                      borderColor: _accentColor.withOpacity(0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DecodeScreen(),
                          ),
                        );
                      },
                    ),
                    FeatureCard(
                      title: 'Bilgi',
                      description: 'Steganografi hakkında bilgi edinme',
                      icon: Icons.info_outline,
                      backgroundColor: _surfaceColor,
                      iconColor: _accentColor,
                      textColor: _textColor,
                      borderColor: _accentColor.withOpacity(0.3),
                      onTap: () {
                        _showInfoDialog(context);
                      },
                    ),
                    FeatureCard(
                      title: 'Ayarlar',
                      description: 'Uygulama ayarlarını özelleştir',
                      icon: Icons.settings,
                      backgroundColor: _surfaceColor,
                      iconColor: _accentColor,
                      textColor: _textColor,
                      borderColor: _accentColor.withOpacity(0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surfaceColor,
        title: Text(
          'Steganografi Nedir?',
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Steganografi, bir veriyi başka bir veri içerisine gizleme sanatıdır. '
            'Bu uygulama, gri tonlamalı bir görüntüyü renkli bir fotoğrafın içerisine, '
            'gözle görülmeyecek şekilde gizlemenize olanak tanır.\n\n'
            'LSB (En Önemsiz Bit) yöntemi kullanarak, renkli fotoğrafın piksellerinin '
            'en az önemli bitlerini değiştirerek gri görüntüyü saklar.',
            style: TextStyle(
              color: _textColor,
              fontSize: 15,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _accentColor.withOpacity(0.3)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: _accentColor,
            ),
            child: const Text('Anladım'),
          ),
        ],
      ),
    );
  }
}