// lib/utils/image_processor.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessor {
  // Görüntü analizi yaparak steganografi için uygunluğunu kontrol eder
  static Future<Map<String, dynamic>> analyzeImages(File coverImage, File secretImage) async {
    // Görüntüleri yükle
    final coverImageBytes = await coverImage.readAsBytes();
    final secretImageBytes = await secretImage.readAsBytes();
    
    // Görüntüleri decode et
    final decodedCoverImage = img.decodeImage(coverImageBytes);
    final decodedSecretImage = img.decodeImage(secretImageBytes);
    
    if (decodedCoverImage == null || decodedSecretImage == null) {
      return {
        'isValid': false,
        'message': 'Görüntüler doğru şekilde yüklenemedi.'
      };
    }
    
    // Gri tonlamalı görüntü kontrolü yap (eğer istenirse)
    // Burada sadece kapasiteyi kontrol ediyoruz, gerekirse dönüştürme işlemi SteganographyService'de yapılacak
    
    // Kapasite kontrolü yap
    // Her pikselde RGB kanallarına dağıtılmış şekilde 8-bit (1 byte) gizlenebilir
    final coverCapacity = (decodedCoverImage.width * decodedCoverImage.height);
    final secretSize = decodedSecretImage.width * decodedSecretImage.height;
    
    // Her pikselde 8 bit saklayabileceğimizi varsayarsak
    final isCapacitySufficient = coverCapacity >= secretSize;
    
    if (!isCapacitySufficient) {
      return {
        'isValid': false,
        'message': 'Kapsayıcı görüntü kapasitesi, gizlenecek görüntü için yetersiz.'
      };
    }
    
    // Önerilen boyutlandırma
    final suggestedWidth = decodedCoverImage.width ~/ 2;
    final suggestedHeight = decodedCoverImage.height ~/ 2;
    
    return {
      'isValid': true,
      'coverWidth': decodedCoverImage.width,
      'coverHeight': decodedCoverImage.height,
      'secretWidth': decodedSecretImage.width,
      'secretHeight': decodedSecretImage.height,
      'suggestedWidth': suggestedWidth,
      'suggestedHeight': suggestedHeight,
      'message': 'Görüntüler steganografi işlemi için uygun.'
    };
  }
  
  // Görüntü kontrastını ve netliğini geliştirir (özellikle çıkarılan gri görüntüler için)
  static Future<File> enhanceImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes)!;
      
      // Görüntüyü geliştir
      final enhancedImage = img.adjustColor(
        decodedImage,
        contrast: 1.2, // Kontrast artırma
        brightness: 0.05, // Hafif parlaklık artışı
      );
      
      // Görüntüyü netleştirme filtresi uygula
      final sharpenedImage = img.convolution(
        enhancedImage,
        filter: [
          0, -1, 0,
        -1,  5, -1,
          0, -1, 0
        ],
      );

      
      // Sonucu PNG olarak kaydet
      final resultBytes = img.encodePng(sharpenedImage);
      
      // Yeni dosya oluştur
      final resultPath = imageFile.path.replaceFirst('.png', '_enhanced.png');
      final resultFile = File(resultPath);
      await resultFile.writeAsBytes(Uint8List.fromList(resultBytes));
      
      return resultFile;
    } catch (e) {
      throw Exception('Görüntü iyileştirme işlemi başarısız: $e');
    }
  }
}