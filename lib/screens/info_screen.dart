// lib/screens/info_screen.dart
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steganografi Hakkında'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Steganografi Nedir?'),
            _buildParagraph(
              'Steganografi, verileri başka verilerin içerisinde gizleme sanatı ve bilimidir. '
              'Bu teknik, gizli bilgilerin üçüncü taraflarca tespit edilmesini önlemek amacıyla kullanılır.',
            ),
            
            _buildSectionTitle('LSB (En Düşük Anlamlı Bit) Yöntemi'),
            _buildParagraph(
              'LSB tekniği, bir görüntünün piksel değerlerinin en az önemli bitlerini değiştirerek '
              'veri saklamaya dayanır. İnsan gözü bu ufak değişiklikleri algılayamaz. Her pikselin '
              'RGB kanallarının en düşük bitleri değiştirilerek bilgi saklanır.',
            ),
            
            _buildInfoImage('lsb_explanation.png'),
            
            _buildSectionTitle('hafiyyat Nasıl Çalışır?'),
            _buildNumberedList([
              'Renkli bir kapsayıcı görüntü seçin.',
              'Gizlemek istediğiniz gri tonlamalı görüntüyü seçin.',
              'Uygulama, gri görüntünün boyutlarını renkli görüntünün kapasitesine göre ayarlar.',
              'LSB yöntemi ile gri görüntü, renkli görüntünün piksellerine dağıtılarak saklanır.',
              'Oluşan stego görüntü, normal bir fotoğraf olarak görünür.',
              'Gizli görüntüyü çıkarmak için stego görüntüyü "Görüntü Çıkar" bölümüne yükleyin.',
            ]),
            
            _buildSectionTitle('Güvenlik Önlemleri'),
            _buildParagraph(
              'Steganografi, bilgi güvenliği için tek başına yeterli değildir. En iyi sonuç için '
              'kriptografi gibi diğer güvenlik yöntemleriyle birlikte kullanılmalıdır.',
            ),
            
            _buildSectionTitle('Uygulama Özellikleri'),
            _buildFeatureList([
              'Gri görüntüleri renkli görüntülere gizleme',
              'Gizlenmiş görüntüleri çıkarma',
              'Otomatik boyut uyumu',
              'Düşük görsel bozulma',
              'Yüksek kaliteli çıkarma işlemi',
            ]),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
  
  Widget _buildInfoImage(String imageName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/$imageName',
            width: 320,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  
  Widget _buildNumberedList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final text = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildFeatureList(List<String> features) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}