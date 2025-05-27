// lib/services/steganography_service.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:hafiyyat/services/encryption_service.dart';

class SteganographyService {
  static const int HEADER_SIZE = 96; // 32 bits each for width, height, and size

  Future<String> encodeImage({
    required String coverImagePath,
    required String secretImagePath,
    String? encryptionKey,
  }) async {
    File? tempFile;
    try {
      print('Encoding process started...');
      print('Cover image path: $coverImagePath');
      print('Secret image path: $secretImagePath');
      print('Encryption key provided: ${encryptionKey != null}');

      // Validate file existence
      if (!await File(coverImagePath).exists()) {
        throw Exception('Cover image file does not exist: $coverImagePath');
      }
      if (!await File(secretImagePath).exists()) {
        throw Exception('Secret image file does not exist: $secretImagePath');
      }

      // Load and validate images in isolate
      final imageLoadResult = await compute(_loadAndValidateImages, {
        'coverImagePath': coverImagePath,
        'secretImagePath': secretImagePath,
      });

      final coverImageBytes = imageLoadResult['coverImageBytes'] as Uint8List;
      final secretImageBytes = imageLoadResult['secretImageBytes'] as Uint8List;
      final coverImage = imageLoadResult['coverImage'] as img.Image;
      final secretImage = imageLoadResult['secretImage'] as img.Image;

      print('Images loaded and validated successfully');
      print('Cover image: ${coverImage.width}x${coverImage.height}');
      print('Secret image: ${secretImage.width}x${secretImage.height}');

      // Encrypt secret image bytes before encoding
      print('Encrypting secret image...');
      if(encryptionKey == null || encryptionKey.isEmpty) {
        encryptionKey = "melazgirt";
      }
      final encryptedSecretBytes = encryptionKey != null 
          ? await EncryptionService.encryptBytes(secretImageBytes, encryptionKey)
          : secretImageBytes;
      print('Secret image ${encryptionKey != null ? "encrypted" : "prepared"}: ${encryptedSecretBytes.length} bytes');
      
      // Process encoding in background
      print('Starting encoding process...');
      final resultImage = await compute(_processEncoding, {
        'coverImageBytes': coverImageBytes,
        'secretImageBytes': encryptedSecretBytes,
      });

      // Save result with maximum compression
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Use optimized PNG encoding with maximum compression
      final pngBytes = await compute(_encodePng, resultImage);
      
      // Save to temp directory
      final tempDir = Directory.systemTemp;
      final tempPath = '${tempDir.path}/stego_temp_$timestamp.png';
      await File(tempPath).writeAsBytes(pngBytes);

      // Get external storage directory
      final appDir = await getExternalStorageDirectory();
      if (appDir == null) {
        throw Exception('External storage directory not available');
      }

      // Create Hafiyyat directory
      final hafiyyatDir = Directory('${appDir.path}/Hafiyyat');
      if (!hafiyyatDir.existsSync()) {
        hafiyyatDir.createSync(recursive: true);
      }

      final finalPath = '${hafiyyatDir.path}/hafiyyat_$timestamp.png';
      
      // Copy to final location and cleanup
      tempFile = File(tempPath);
      await tempFile.copy(finalPath);
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }

      print('Result saved: $finalPath');
      return finalPath;

    } catch (e) {
      if (tempFile != null && tempFile.existsSync()) {
        await tempFile.delete();
      }
      print('Encoding error: $e');
      rethrow;
    }
  }

  Future<String> decodeImage({
    required String stegoImagePath,
    String? encryptionKey,
  }) async {
    File? tempFile;
    try {
      print('Decoding process started...');
      print('Stego image path: $stegoImagePath');
      print('Encryption key provided: ${encryptionKey != null}');

      // Load stego image in isolate
      final stegoImageBytes = await compute(_loadImage, stegoImagePath);
      
      // Process decoding in background
      final extractedEncryptedBytes = await compute(_processDecoding, {
        'stegoImageBytes': stegoImageBytes,
      });

      Uint8List decryptedBytes;
      try {
        // Decrypt the extracted bytes if key is provided
        print('Decrypting extracted bytes...');
        print(encryptionKey);
        if(encryptionKey == null || encryptionKey.isEmpty) {
          encryptionKey = "melazgirt";
        }
        decryptedBytes = (encryptionKey != null || encryptionKey!.isNotEmpty)
            ? await EncryptionService.decryptBytes(extractedEncryptedBytes, encryptionKey)
            : extractedEncryptedBytes;
      } catch (e) {
        if (e.toString().contains('InvalidCipherTextException')) {
          throw Exception('Şifre çözme hatası: Yanlış anahtar veya şifrelenmemiş görüntü.');
        }
        throw Exception('Şifre çözme hatası: ${e.toString()}');
      }

      // Validate decrypted data is a valid image
      if (!_isValidImage(decryptedBytes)) {
        throw Exception('Geçersiz görüntü verisi: Görüntü bozuk veya yanlış anahtar kullanılmış olabilir.');
      }
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Save to temp directory
      final tempDir = Directory.systemTemp;
      final tempPath = '${tempDir.path}/extracted_temp_$timestamp.png';
      await File(tempPath).writeAsBytes(decryptedBytes);

      // Get external storage directory
      final appDir = await getExternalStorageDirectory();
      if (appDir == null) {
        throw Exception('External storage directory not available');
      }

      // Create Hafiyyat directory
      final hafiyyatDir = Directory('${appDir.path}/Hafiyyat');
      if (!hafiyyatDir.existsSync()) {
        hafiyyatDir.createSync(recursive: true);
      }

      final finalPath = '${hafiyyatDir.path}/extracted_$timestamp.png';
      
      // Copy to final location and cleanup
      tempFile = File(tempPath);
      await tempFile.copy(finalPath);
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }

      print('Extracted image saved: $finalPath');
      return finalPath;

    } catch (e) {
      if (tempFile != null && tempFile.existsSync()) {
        await tempFile.delete();
      }
      print('Decoding error: $e');
      rethrow;
    }
  }

  // Helper function for PNG encoding in isolate
  static Uint8List _encodePng(img.Image image) {
    return img.encodePng(
      image,
      level: 9,
      filter: img.PngFilter.paeth,
    );
  }

  static Future<img.Image> _processEncoding(Map<String, dynamic> data) async {
    try {
      final coverImageBytes = data['coverImageBytes'] as Uint8List;
      final secretImageBytes = data['secretImageBytes'] as Uint8List;

      print('Processing encoding - Cover bytes: ${coverImageBytes.length}, Secret bytes: ${secretImageBytes.length}');

      // Decode images
      final coverImage = img.decodeImage(coverImageBytes);
      if (coverImage == null) {
        throw Exception('Failed to decode cover image in processing');
      }
      print('Cover image decoded in processing: ${coverImage.width}x${coverImage.height}');

      // Calculate maximum capacity
      final maxBytes = ((coverImage.width * coverImage.height - HEADER_SIZE) ~/ 8);
      print('Maximum capacity: $maxBytes bytes');
      
      if (secretImageBytes.length > maxBytes) {
        throw Exception(
          'Secret data too large. Maximum size: $maxBytes bytes, '
          'Required: ${secretImageBytes.length} bytes'
        );
      }

      // Create result image
      final resultImage = img.Image.from(coverImage);
      
      // Convert image data to bytes for batch processing
      final pixels = Uint8List(resultImage.width * resultImage.height * 4); // RGBA format
      int pixelIndex = 0;
      
      for (int y = 0; y < resultImage.height; y++) {
        for (int x = 0; x < resultImage.width; x++) {
          final pixel = resultImage.getPixel(x, y);
          pixels[pixelIndex] = pixel.r.toInt();
          pixels[pixelIndex + 1] = pixel.g.toInt();
          pixels[pixelIndex + 2] = pixel.b.toInt();
          pixels[pixelIndex + 3] = pixel.a.toInt();
          pixelIndex += 4;
        }
      }
      
      final secretBits = _bytesToBits(secretImageBytes);
      
      // Embed header using batch operation
      _embedHeaderBatch(pixels, coverImage.width, coverImage.height, secretImageBytes.length);
      
      // Embed data using batch operation
      _embedDataBatch(pixels, secretBits);
      
      // Update image pixels
      pixelIndex = 0;
      for (int y = 0; y < resultImage.height; y++) {
        for (int x = 0; x < resultImage.width; x++) {
          resultImage.setPixel(x, y, img.ColorRgba8(
            pixels[pixelIndex],
            pixels[pixelIndex + 1],
            pixels[pixelIndex + 2],
            pixels[pixelIndex + 3],
          ));
          pixelIndex += 4;
        }
      }

      return resultImage;
    } catch (e) {
      print('Error in _processEncoding: $e');
      rethrow;
    }
  }

  static Future<Uint8List> _processDecoding(Map<String, dynamic> data) async {
    final stegoImageBytes = data['stegoImageBytes'] as Uint8List;
    
    // Decode stego image
    final stegoImage = img.decodeImage(stegoImageBytes);
    if (stegoImage == null) {
      throw Exception('Failed to decode stego image');
    }
    
    // Extract header
    final header = _extractHeader(stegoImage);
    final width = header['width']!;
    final height = header['height']!;
    final dataSize = header['dataSize']!;
    
    print('Extracted header - Width: $width, Height: $height, Size: $dataSize bytes');
    
    if (width <= 0 || height <= 0 || width > stegoImage.width || height > stegoImage.height) {
      throw Exception('Invalid dimensions in header: ${width}x$height');
    }
    
    // Extract data
    final extractedBytes = _extractData(stegoImage, dataSize);
    
    return extractedBytes;
  }

  // New isolate functions
  static Future<Uint8List> _loadImage(String path) async {
    return await File(path).readAsBytes();
  }

  static Map<String, dynamic> _loadAndValidateImages(Map<String, String> params) {
    final coverImagePath = params['coverImagePath']!;
    final secretImagePath = params['secretImagePath']!;

    final coverImageBytes = File(coverImagePath).readAsBytesSync();
    final secretImageBytes = File(secretImagePath).readAsBytesSync();

    // Decode images with size limits
    final coverImage = img.decodeImage(coverImageBytes);
    final secretImage = img.decodeImage(secretImageBytes);

    if (coverImage == null) {
      throw Exception('Failed to decode cover image. Invalid format or corrupted file.');
    }
    if (secretImage == null) {
      throw Exception('Failed to decode secret image. Invalid format or corrupted file.');
    }

    // Resize images if they are too large
    final maxWidth = 1024;
    final maxHeight = 1024;
    
    final resizedCoverImage = (coverImage.width > maxWidth || coverImage.height > maxHeight)
        ? img.copyResize(
            coverImage,
            width: maxWidth,
            height: maxHeight,
            interpolation: img.Interpolation.linear,
          )
        : coverImage;

    // Resize secret image relative to cover image
    final maxSecretWidth = resizedCoverImage.width ~/ 2;
    final maxSecretHeight = resizedCoverImage.height ~/ 2;
    
    final resizedSecretImage = (secretImage.width > maxSecretWidth || secretImage.height > maxSecretHeight)
        ? img.copyResize(
            secretImage,
            width: maxSecretWidth,
            height: maxSecretHeight,
            interpolation: img.Interpolation.linear,
          )
        : secretImage;

    return {
      'coverImageBytes': img.encodePng(resizedCoverImage),
      'secretImageBytes': img.encodePng(resizedSecretImage),
      'coverImage': resizedCoverImage,
      'secretImage': resizedSecretImage,
    };
  }

  static Map<String, int> _extractHeader(img.Image image) {
    int bitIndex = 0;
    int width = 0;
    int height = 0;
    int dataSize = 0;
    
    try {
      // Extract width (32 bits)
      for (int i = 0; i < 32; i++) {
        final x = bitIndex % image.width;
        final y = bitIndex ~/ image.width;
        final bit = image.getPixel(x, y).r.toInt() & 1;
        width |= bit << i;
        bitIndex++;
      }
      
      // Extract height (32 bits)
      for (int i = 0; i < 32; i++) {
        final x = bitIndex % image.width;
        final y = bitIndex ~/ image.width;
        final bit = image.getPixel(x, y).r.toInt() & 1;
        height |= bit << i;
        bitIndex++;
      }
      
      // Extract data size (32 bits)
      for (int i = 0; i < 32; i++) {
        final x = bitIndex % image.width;
        final y = bitIndex ~/ image.width;
        final bit = image.getPixel(x, y).r.toInt() & 1;
        dataSize |= bit << i;
        bitIndex++;
      }

      // Validate extracted dimensions
      if (width <= 0 || width > 4096 || height <= 0 || height > 4096 || 
          dataSize <= 0 || dataSize > 16777216) { // 16MB limit
        throw Exception('Invalid header values detected');
      }

      print('Extracted header - Width: $width, Height: $height, Size: $dataSize');
      
      return {
        'width': width,
        'height': height,
        'dataSize': dataSize
      };
    } catch (e) {
      print('Header extraction error: $e');
      throw Exception('Görüntüden veri çıkarılamadı: Header bilgisi okunamıyor veya bozuk.');
    }
  }

  static Uint8List _extractData(img.Image image, int dataSize) {
    final data = Uint8List(dataSize);
    int bitIndex = HEADER_SIZE;
    
    try {
      for (int byteIndex = 0; byteIndex < dataSize; byteIndex++) {
        int byte = 0;
        for (int i = 0; i < 8; i++) {
          final x = bitIndex % image.width;
          final y = bitIndex ~/ image.width;
          
          if (y >= image.height) {
            throw Exception('Veri boyutu görüntü kapasitesini aşıyor');
          }
          
          byte |= (image.getPixel(x, y).r.toInt() & 1) << i;
          bitIndex++;
        }
        data[byteIndex] = byte;
        
        if (byteIndex % 1000 == 0) {
          print('Extracted ${byteIndex + 1} of $dataSize bytes');
        }
      }
      
      return data;
    } catch (e) {
      print('Data extraction error: $e');
      throw Exception('Veri çıkarma hatası: Görüntü bozuk veya yanlış formatta.');
    }
  }

  static void _embedHeader(img.Image image, int width, int height, int dataSize) {
    print('Embedding header - Width: $width, Height: $height, Size: $dataSize');
    int bitIndex = 0;
    
    // Embed width (32 bits)
    for (int i = 0; i < 32; i++) {
      _embedBit(image, bitIndex, (width >> i) & 1);
      bitIndex++;
    }
    
    // Embed height (32 bits)
    for (int i = 0; i < 32; i++) {
      _embedBit(image, bitIndex, (height >> i) & 1);
      bitIndex++;
    }
    
    // Embed data size (32 bits)
    for (int i = 0; i < 32; i++) {
      _embedBit(image, bitIndex, (dataSize >> i) & 1);
      bitIndex++;
    }
  }

  static void _embedData(img.Image image, Uint8List data) {
    int bitIndex = HEADER_SIZE;
    
    for (int byteIndex = 0; byteIndex < data.length; byteIndex++) {
      int byte = data[byteIndex];
      for (int i = 0; i < 8; i++) {
        _embedBit(image, bitIndex, (byte >> i) & 1);
        bitIndex++;
      }
      
      if (byteIndex % 1000 == 0) {
        print('Embedded ${byteIndex + 1} of ${data.length} bytes');
      }
    }
  }

  static void _embedBit(img.Image image, int bitIndex, int bit) {
    final x = bitIndex % image.width;
    final y = bitIndex ~/ image.width;
    
    if (y >= image.height) {
      throw Exception('Image capacity exceeded at bit $bitIndex');
    }
    
    final pixel = image.getPixel(x, y);
    final newR = (pixel.r.toInt() & ~1) | (bit & 1);
    image.setPixel(x, y, img.ColorRgba8(newR, pixel.g.toInt(), pixel.b.toInt(), pixel.a.toInt()));
  }

  static Uint8List _imageToBytes(img.Image image) {
    final bytes = Uint8List(image.width * image.height);
    int index = 0;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        bytes[index] = pixel.r.toInt();
        index++;
      }
    }
    
    return bytes;
  }

  static img.Image _bytesToImage(Uint8List bytes, int width, int height) {
    final image = img.Image(width: width, height: height);
    int index = 0;
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (index >= bytes.length) break;
        final gray = bytes[index];
        image.setPixel(x, y, img.ColorRgba8(gray, gray, gray, 255));
        index++;
      }
    }
    
    return image;
  }

  // New optimized batch processing methods
  static void _embedHeaderBatch(Uint8List pixels, int width, int height, int dataSize) {
    int bitIndex = 0;
    final headerBits = <int>[];
    
    // Prepare all header bits
    for (int value in [width, height, dataSize]) {
      for (int i = 0; i < 32; i++) {
        headerBits.add((value >> i) & 1);
      }
    }
    
    // Embed header bits in batch - use only red channel
    for (int i = 0; i < HEADER_SIZE; i++) {
      final pixelIndex = i * 4; // RGBA format, so each pixel is 4 bytes
      pixels[pixelIndex] = (pixels[pixelIndex] & ~1) | headerBits[i];
    }
  }

  static void _embedDataBatch(Uint8List pixels, List<int> secretBits) {
    for (int i = 0; i < secretBits.length; i++) {
      final pixelIndex = (i + HEADER_SIZE) * 4; // RGBA format, starting after header
      if (pixelIndex + 3 >= pixels.length) break;
      pixels[pixelIndex] = (pixels[pixelIndex] & ~1) | secretBits[i];
    }
  }

  static List<int> _bytesToBits(Uint8List bytes) {
    final bits = <int>[];
    for (int byte in bytes) {
      for (int i = 0; i < 8; i++) {
        bits.add((byte >> i) & 1);
      }
    }
    return bits;
  }

  // Add new validation method
  static bool _isValidImage(Uint8List bytes) {
    try {
      // Try to decode the bytes as an image
      final image = img.decodeImage(bytes);
      return image != null && image.width > 0 && image.height > 0;
    } catch (e) {
      return false;
    }
  }
}
