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
  }) async {
    File? tempFile;
    try {
      print('Encoding process started...');
      print('Cover image path: $coverImagePath');
      print('Secret image path: $secretImagePath');

      // Validate file existence
      if (!await File(coverImagePath).exists()) {
        throw Exception('Cover image file does not exist: $coverImagePath');
      }
      if (!await File(secretImagePath).exists()) {
        throw Exception('Secret image file does not exist: $secretImagePath');
      }

      // Load images with validation
      final coverImageBytes = await File(coverImagePath).readAsBytes();
      print('Cover image bytes loaded: ${coverImageBytes.length} bytes');
      
      final secretImageBytes = await File(secretImagePath).readAsBytes();
      print('Secret image bytes loaded: ${secretImageBytes.length} bytes');
      
      // Validate image formats
      final coverImage = img.decodeImage(coverImageBytes);
      if (coverImage == null) {
        throw Exception('Failed to decode cover image. Invalid format or corrupted file.');
      }
      print('Cover image decoded successfully: ${coverImage.width}x${coverImage.height}');
      
      final secretImage = img.decodeImage(secretImageBytes);
      if (secretImage == null) {
        throw Exception('Failed to decode secret image. Invalid format or corrupted file.');
      }
      print('Secret image decoded successfully: ${secretImage.width}x${secretImage.height}');

      // Encrypt secret image bytes before encoding
      print('Encrypting secret image...');
      final encryptedSecretBytes = EncryptionService.encryptBytes(secretImageBytes);
      print('Secret image encrypted: ${encryptedSecretBytes.length} bytes');
      
      // Process encoding in background
      print('Starting encoding process...');
      final resultImage = await compute(_processEncoding, {
        'coverImageBytes': coverImageBytes,
        'secretImageBytes': encryptedSecretBytes,
      });

      // Save result with maximum compression
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempPath = '${tempDir.path}/stego_temp_$timestamp.png';
      tempFile = File(tempPath);
      
      // Use maximum PNG compression
      final pngBytes = img.encodePng(resultImage, level: 9);
      await tempFile.writeAsBytes(pngBytes);

      // Get the pictures directory
      final appDir = await getExternalStorageDirectory();
      if (appDir == null) {
        throw Exception('External storage directory not available');
      }

      // Create Hafiyyat directory if it doesn't exist
      final hafiyyatDir = Directory('${appDir.path}/Hafiyyat');
      if (!await hafiyyatDir.exists()) {
        await hafiyyatDir.create(recursive: true);
      }

      // Generate final path
      final finalPath = '${hafiyyatDir.path}/hafiyyat_$timestamp.png';
      await tempFile.copy(finalPath);
      print('Result saved: $finalPath');

      // Clean up temp file
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }

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
  }) async {
    File? tempFile;
    try {
      print('Decoding process started...');
      print('Stego image: $stegoImagePath');

      // Load stego image
      final stegoImageBytes = await File(stegoImagePath).readAsBytes();
      
      // Process decoding in background and decrypt the result
      final extractedEncryptedBytes = await compute(_processDecoding, {
        'stegoImageBytes': stegoImageBytes,
      });
      
      // Decrypt the extracted bytes
      final decryptedBytes = EncryptionService.decryptBytes(extractedEncryptedBytes);
      
      // Convert decrypted bytes to image
      final extractedImage = img.decodeImage(decryptedBytes);
      if (extractedImage == null) {
        throw Exception('Failed to decode extracted image');
      }

      // Convert image to PNG bytes for saving
      final pngBytes = img.encodePng(extractedImage);

      // Save result
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempPath = '${tempDir.path}/extracted_temp_$timestamp.png';
      tempFile = File(tempPath);
      
      await tempFile.writeAsBytes(pngBytes);

      // Get the pictures directory
      final appDir = await getExternalStorageDirectory();
      if (appDir == null) {
        throw Exception('External storage directory not available');
      }

      // Create Hafiyyat directory if it doesn't exist
      final hafiyyatDir = Directory('${appDir.path}/Hafiyyat');
      if (!await hafiyyatDir.exists()) {
        await hafiyyatDir.create(recursive: true);
      }

      // Generate final path
      final finalPath = '${hafiyyatDir.path}/extracted_$timestamp.png';
      await tempFile.copy(finalPath);
      print('Extracted image saved: $finalPath');

      // Clean up temp file
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }

      return finalPath;
    } catch (e) {
      if (tempFile != null && tempFile.existsSync()) {
        await tempFile.delete();
      }
      print('Decoding error: $e');
      rethrow;
    }
  }

  static img.Image _processEncoding(Map<String, dynamic> data) {
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
      
      // Embed header
      _embedHeader(resultImage, coverImage.width, coverImage.height, secretImageBytes.length);
      print('Header embedded successfully');
      
      // Embed data
      _embedData(resultImage, secretImageBytes);
      print('Data embedded successfully');

      return resultImage;
    } catch (e) {
      print('Error in _processEncoding: $e');
      rethrow;
    }
  }

  static Uint8List _processDecoding(Map<String, dynamic> data) {
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

  static Map<String, int> _extractHeader(img.Image image) {
    int bitIndex = 0;
    int width = 0;
    int height = 0;
    int dataSize = 0;
    
    // Extract width (32 bits)
    for (int i = 0; i < 32; i++) {
      width |= _extractBit(image, bitIndex) << i;
      bitIndex++;
    }
    
    // Extract height (32 bits)
    for (int i = 0; i < 32; i++) {
      height |= _extractBit(image, bitIndex) << i;
      bitIndex++;
    }
    
    // Extract data size (32 bits)
    for (int i = 0; i < 32; i++) {
      dataSize |= _extractBit(image, bitIndex) << i;
      bitIndex++;
    }

    return {
      'width': width,
      'height': height,
      'dataSize': dataSize
    };
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

  static Uint8List _extractData(img.Image image, int dataSize) {
    final data = Uint8List(dataSize);
    int bitIndex = HEADER_SIZE;
    
    for (int byteIndex = 0; byteIndex < dataSize; byteIndex++) {
      int byte = 0;
      for (int i = 0; i < 8; i++) {
        byte |= _extractBit(image, bitIndex) << i;
        bitIndex++;
      }
      data[byteIndex] = byte;
      
      if (byteIndex % 1000 == 0) {
        print('Extracted ${byteIndex + 1} of $dataSize bytes');
      }
    }
    
    return data;
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

  static int _extractBit(img.Image image, int bitIndex) {
    final x = bitIndex % image.width;
    final y = bitIndex ~/ image.width;
    
    if (y >= image.height) {
      throw Exception('Image bounds exceeded at bit $bitIndex');
    }
    
    return image.getPixel(x, y).r.toInt() & 1;
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
}
