// lib/services/steganography_service.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class SteganographyService {
  static const int CHUNK_SIZE = 50; // Reduced chunk size for better memory management

  Future<String> encodeImage({
    required String coverImagePath,
    required String secretImagePath,
  }) async {
    try {
      print('İşlem başlatılıyor...');
      print('Kapsayıcı görüntü: $coverImagePath');
      print('Gizlenecek görüntü: $secretImagePath');

      // Load and validate images
      final coverImageFile = File(coverImagePath);
      final secretImageFile = File(secretImagePath);
      
      if (!await coverImageFile.exists()) {
        throw Exception('Kapsayıcı görüntü bulunamadı: $coverImagePath');
      }
      if (!await secretImageFile.exists()) {
        throw Exception('Gizlenecek görüntü bulunamadı: $secretImagePath');
      }

      // Get file sizes for debugging
      final coverSize = await coverImageFile.length();
      final secretSize = await secretImageFile.length();
      print('Kapsayıcı görüntü boyutu: ${(coverSize / 1024).toStringAsFixed(2)} KB');
      print('Gizlenecek görüntü boyutu: ${(secretSize / 1024).toStringAsFixed(2)} KB');

      // Read images as bytes to reduce memory usage
      Uint8List? coverImageBytes;
      Uint8List? secretImageBytes;
      
      try {
        coverImageBytes = await coverImageFile.readAsBytes();
        secretImageBytes = await secretImageFile.readAsBytes();
      } catch (e) {
        throw Exception('Görüntü okuma hatası: $e');
      }
      
      // Process encoding in background with chunking
      final resultImage = await compute(_processEncodingOptimized, {
        'coverImageBytes': coverImageBytes,
        'secretImageBytes': secretImageBytes,
        'chunkSize': CHUNK_SIZE,
      }).catchError((error) {
        throw Exception('İşleme hatası: $error');
      });

      // Save result with optimized PNG encoding
      final pngBytes = img.encodePng(resultImage, level: 6); // Balanced compression
      final tempDir = await getTemporaryDirectory();
      final resultPath = '${tempDir.path}/stego_result_${DateTime.now().millisecondsSinceEpoch}.png';
      
      // Write file with error handling
      try {
        final resultFile = File(resultPath);
        await resultFile.writeAsBytes(pngBytes);
        
        // Verify the file was written correctly
        if (!await resultFile.exists()) {
          throw Exception('Sonuç dosyası oluşturulamadı');
        }
        
        final resultSize = await resultFile.length();
        print('Sonuç görüntüsü boyutu: ${(resultSize / 1024).toStringAsFixed(2)} KB');
        print('Sonuç dosyası: $resultPath');
        
        return resultPath;
      } catch (e) {
        throw Exception('Sonuç dosyası kaydedilemedi: $e');
      }
    } catch (e) {
      print('Encoding error details: $e'); // Detailed logging
      throw Exception('Görüntü gizleme işlemi başarısız: ${e.toString()}');
    }
  }

  Future<String> decodeImage({
    required String stegoImagePath,
  }) async {
    try {
      print('Gizli görüntü çıkarılıyor...');
      
      // Validate input file
      final stegoImageFile = File(stegoImagePath);
      if (!await stegoImageFile.exists()) {
        throw Exception('Stego görüntü bulunamadı: $stegoImagePath');
      }

      // Get file size for debugging
      final stegoSize = await stegoImageFile.length();
      print('Stego görüntü boyutu: ${(stegoSize / 1024).toStringAsFixed(2)} KB');

      // Read image bytes
      Uint8List? stegoImageBytes;
      try {
        stegoImageBytes = await stegoImageFile.readAsBytes();
      } catch (e) {
        throw Exception('Görüntü okuma hatası: $e');
      }
      
      // Process decoding in background with chunking
      final extractedImage = await compute(_processDecodingOptimized, {
        'stegoImageBytes': stegoImageBytes,
        'chunkSize': CHUNK_SIZE,
      }).catchError((error) {
        throw Exception('İşleme hatası: $error');
      });
      
      // Save result with optimized PNG encoding
      final pngBytes = img.encodePng(extractedImage, level: 6);
      final tempDir = await getTemporaryDirectory();
      final resultPath = '${tempDir.path}/extracted_image_${DateTime.now().millisecondsSinceEpoch}.png';
      
      // Write file with error handling
      try {
        final resultFile = File(resultPath);
        await resultFile.writeAsBytes(pngBytes);
        
        // Verify the file was written correctly
        if (!await resultFile.exists()) {
          throw Exception('Sonuç dosyası oluşturulamadı');
        }
        
        final resultSize = await resultFile.length();
        print('Çıkarılan görüntü boyutu: ${(resultSize / 1024).toStringAsFixed(2)} KB');
        print('Çıkarılan görüntü: ${extractedImage.width}x${extractedImage.height} piksel');
        print('Sonuç dosyası: $resultPath');
        
        return resultPath;
      } catch (e) {
        throw Exception('Çıkarılan görüntü kaydedilemedi: $e');
      }
    } catch (e) {
      print('Decoding error details: $e'); // Detailed logging
      throw Exception('Görüntü çıkarma işlemi başarısız: ${e.toString()}');
    }
  }

  // Optimized encoding process with chunking
  static img.Image _processEncodingOptimized(Map<String, dynamic> data) {
    try {
      final coverImageBytes = data['coverImageBytes'] as Uint8List;
      final secretImageBytes = data['secretImageBytes'] as Uint8List;
      final chunkSize = data['chunkSize'] as int;

      // Decode images with error handling
      final coverImage = img.decodeImage(coverImageBytes);
      final secretImage = img.decodeImage(secretImageBytes);
      
      if (coverImage == null) {
        throw Exception('Kapsayıcı görüntü okunamadı veya desteklenmeyen format');
      }
      if (secretImage == null) {
        throw Exception('Gizlenecek görüntü okunamadı veya desteklenmeyen format');
      }

      print('Görüntü boyutları:');
      print('Kapsayıcı: ${coverImage.width}x${coverImage.height}');
      print('Gizlenecek: ${secretImage.width}x${secretImage.height}');

      // Convert secret image to grayscale
      final grayscaleSecret = img.grayscale(secretImage);
      
      // Size validation
      final maxSecretSize = ((coverImage.width * (coverImage.height - 1) * 8) ~/ 256);
      final secretSize = grayscaleSecret.width * grayscaleSecret.height;
      
      print('Maksimum gizlenebilir piksel: $maxSecretSize');
      print('Gizlenecek piksel sayısı: $secretSize');
      
      if (secretSize > maxSecretSize) {
        throw Exception(
          'Gizlenecek görüntü çok büyük. Maksimum boyut: $maxSecretSize piksel, '
          'Gizlenecek görüntü boyutu: $secretSize piksel'
        );
      }

      final resultImage = img.Image.from(coverImage);
      
      // Embed dimensions in header
      _embedDimensions(resultImage, grayscaleSecret.width, grayscaleSecret.height);
      
      // Process image in chunks
      int startY = 4; // Start after header
      for (int chunkStart = 0; chunkStart < secretSize; chunkStart += chunkSize) {
        int chunkEnd = (chunkStart + chunkSize < secretSize) ? chunkStart + chunkSize : secretSize;
        _processChunk(resultImage, grayscaleSecret, startY, chunkStart, chunkEnd);
      }

      return resultImage;
    } catch (e) {
      print('Encoding process error: $e');
      rethrow;
    }
  }

  // Optimized decoding process with chunking
  static img.Image _processDecodingOptimized(Map<String, dynamic> data) {
    final stegoImageBytes = data['stegoImageBytes'] as Uint8List;
    final chunkSize = data['chunkSize'] as int;
    
    // Decode image with error handling
    final stegoImage = img.decodeImage(stegoImageBytes);
    if (stegoImage == null) {
      throw Exception('Stego görüntü okunamadı');
    }
    
    // Extract dimensions from header
    final dimensions = _extractDimensions(stegoImage);
    final width = dimensions['width']!;
    final height = dimensions['height']!;
    
    if (width <= 0 || height <= 0 || width > stegoImage.width || height > stegoImage.height) {
      throw Exception('Geçersiz boyut bilgisi: ${width}x$height');
    }
    
    final extractedImage = img.Image(width: width, height: height);
    final totalPixels = width * height;
    
    // Process image in chunks
    int startY = 4; // Start after header
    for (int chunkStart = 0; chunkStart < totalPixels; chunkStart += chunkSize) {
      int chunkEnd = (chunkStart + chunkSize < totalPixels) ? chunkStart + chunkSize : totalPixels;
      _extractChunk(stegoImage, extractedImage, startY, chunkStart, chunkEnd);
    }
    
    return extractedImage;
  }

  // Helper methods
  static void _embedDimensions(img.Image image, int width, int height) {
    // Embed width
    for (int i = 0; i < 16; i++) {
      int bit = (width >> i) & 1;
      int x = i % 4;
      int y = i ~/ 4;
      _embedBit(image, x, y, bit);
    }
    
    // Embed height
    for (int i = 0; i < 16; i++) {
      int bit = (height >> i) & 1;
      int x = (i % 4) + 4;
      int y = i ~/ 4;
      _embedBit(image, x, y, bit);
    }
  }

  static Map<String, int> _extractDimensions(img.Image image) {
    int width = 0;
    int height = 0;
    
    // Extract width
    for (int i = 0; i < 16; i++) {
      int x = i % 4;
      int y = i ~/ 4;
      width |= _extractBit(image, x, y) << i;
    }
    
    // Extract height
    for (int i = 0; i < 16; i++) {
      int x = (i % 4) + 4;
      int y = i ~/ 4;
      height |= _extractBit(image, x, y) << i;
    }
    
    return {'width': width, 'height': height};
  }

  static void _processChunk(img.Image resultImage, img.Image grayscaleSecret, int startY, int start, int end) {
    for (int i = start; i < end; i++) {
      int x = i % grayscaleSecret.width;
      int y = i ~/ grayscaleSecret.width;
      
      if (y >= grayscaleSecret.height) break;
      
      final pixel = grayscaleSecret.getPixel(x, y);
      // Convert num to int for pixel values
      int grayValue = ((pixel.r.toInt() + pixel.g.toInt() + pixel.b.toInt()) ~/ 3);
      
      for (int bit = 0; bit < 8; bit++) {
        int targetX = (x * 8 + bit) % resultImage.width;
        int targetY = startY + (x * 8 + bit) ~/ resultImage.width + y * ((8 * grayscaleSecret.width + resultImage.width - 1) ~/ resultImage.width);
        if (targetY >= resultImage.height) continue;
        
        _embedBit(resultImage, targetX, targetY, (grayValue >> bit) & 1);
      }
    }
  }

  static void _extractChunk(img.Image stegoImage, img.Image extractedImage, int startY, int start, int end) {
    for (int i = start; i < end; i++) {
      int x = i % extractedImage.width;
      int y = i ~/ extractedImage.width;
      
      if (y >= extractedImage.height) break;
      
      int grayValue = 0;
      for (int bit = 0; bit < 8; bit++) {
        int targetX = (x * 8 + bit) % stegoImage.width;
        int targetY = startY + (x * 8 + bit) ~/ stegoImage.width + y * ((8 * extractedImage.width + stegoImage.width - 1) ~/ stegoImage.width);
        if (targetY >= stegoImage.height) continue;
        
        grayValue |= _extractBit(stegoImage, targetX, targetY) << bit;
      }
      
      extractedImage.setPixel(x, y, img.ColorRgba8(grayValue, grayValue, grayValue, 255));
    }
  }

  static void _embedBit(img.Image image, int x, int y, int bit) {
    if (x >= image.width || y >= image.height) return;
    final pixel = image.getPixel(x, y);
    final newPixel = img.ColorRgba8(
      (pixel.r.toInt() & 0xFE) | bit,
      pixel.g.toInt(),
      pixel.b.toInt(),
      pixel.a.toInt()
    );
    image.setPixel(x, y, newPixel);
  }

  static int _extractBit(img.Image image, int x, int y) {
    if (x >= image.width || y >= image.height) return 0;
    final pixel = image.getPixel(x, y);
    return pixel.r.toInt() & 1;
  }
}
