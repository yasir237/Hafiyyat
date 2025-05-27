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
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'BİLGİ GÜÇTÜR',
                  style: TextStyle(
                    color: _accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3.5,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Gizlenen Bilgi, Dünyayı Değiştirir.',
                style: TextStyle(
                  fontSize: 24,
                  color: _textColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  height: 1.25,
                  shadows: [
                    Shadow(
                      color: _textColor.withOpacity(0.1),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _accentColor.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  '01000001 01101100 01110010 01100001 01110111 01101001',
                  style: TextStyle(
                    fontSize: 13,
                    color: _accentColor.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.5,
                    fontFamily: 'monospace',
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Scroll çakışmasını engeller
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