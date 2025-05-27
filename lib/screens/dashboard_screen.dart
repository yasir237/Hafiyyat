// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:hafiyyat/screens/encode_screen.dart';
import 'package:hafiyyat/screens/decode_screen.dart';
import 'package:hafiyyat/screens/info_screen.dart';
import 'package:hafiyyat/utils/file_utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Uygulama başladığında geçici dosyaları temizle
    FileUtils.cleanupTempFiles();
  }

  final List<Widget> _pages = [
    const HomeContent(),
    const EncodeScreen(),
    const DecodeScreen(),
    const InfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.enhanced_encryption),
            label: 'Gizle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.no_encryption),
            label: 'Çıkar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Bilgi',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hafiyyat'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Hoş Geldiniz',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              const Text(
                'hafiyyat, steganografi tekniğiyle fotoğraflarınıza gizli görüntüler gömmenizi sağlar.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              _buildStatCard(context),
              const SizedBox(height: 20),
              _buildFeatureSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Steganografi İstatistikleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  'Güvenlik',
                  '92%',
                  Colors.green,
                  Icons.security,
                ),
                _buildStatItem(
                  context,
                  'Tespit Edilemezlik',
                  '89%',
                  Colors.blue,
                  Icons.visibility_off,
                ),
                _buildStatItem(
                  context,
                  'Veri Bütünlüğü',
                  '95%',
                  Colors.orange,
                  Icons.data_usage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ne yapmak istersiniz?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              context,
              'Görüntü Gizle',
              'Renkli bir fotoğrafa gri görüntüyü gizleyin',
              Icons.enhanced_encryption,
              () {
                (context as Element).markNeedsBuild();
                DefaultTabController.of(context).animateTo(1);
              },
            ),
            _buildFeatureCard(
              context,
              'Görüntüyü Çıkar',
              'Steganografi uygulanmış fotoğraftan gizli görüntüyü çıkarın',
              Icons.no_encryption,
              () {
                (context as Element).markNeedsBuild();
                DefaultTabController.of(context).animateTo(2);
              },
            ),
            _buildFeatureCard(
              context,
              'Steganografi Hakkında',
              'Steganografi teknikleri ve uygulamaları hakkında bilgi edinin',
              Icons.info_outline,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
            ),
            _buildFeatureCard(
              context,
              'Nasıl Çalışır?',
              'Uygulamanın çalışma prensiplerini öğrenin',
              Icons.help_outline,
              () {
                _showHowItWorksDialog(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHowItWorksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nasıl Çalışır?'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Görüntü Gizleme:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '- Renkli bir kapsayıcı görüntü seçin\n'
                '- Gizlemek istediğiniz gri görüntüyü seçin\n'
                '- Gizle butonuna tıklayın\n'
                '- Oluşan görüntüyü kaydedin veya paylaşın',
              ),
              SizedBox(height: 12),
              Text(
                '2. Görüntü Çıkarma:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '- İçinde gizli görüntü bulunan stego görüntüyü seçin\n'
                '- Çıkar butonuna tıklayın\n'
                '- Çıkarılan gri görüntüyü kaydedin veya paylaşın',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anladım'),
          ),
        ],
      ),
    );
  }
}