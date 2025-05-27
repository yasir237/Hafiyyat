import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static IV _generateIV(String customKey) {
    // Generate a deterministic IV based on the custom key
    final keyHash = sha256.convert(utf8.encode(customKey)).bytes;
    return IV(Uint8List.fromList(keyHash.sublist(0, 16)));
  }

  static Key _generateKey(String customKey) {
    // Generate a 256-bit key from the custom key using SHA-256
    final keyHash = sha256.convert(utf8.encode(customKey)).bytes;
    return Key(Uint8List.fromList(keyHash));
  }

  static Uint8List encryptBytes(Uint8List bytes, String customKey) {
    try {
      final key = _generateKey(customKey);
      final iv = _generateIV(customKey);
      
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final encrypted = encrypter.encryptBytes(bytes, iv: iv);
      return encrypted.bytes;
    } catch (e) {
      print('Encryption error: $e');
      rethrow;
    }
  }

  static Uint8List decryptBytes(Uint8List encryptedBytes, String customKey) {
    try {
      final key = _generateKey(customKey);
      final iv = _generateIV(customKey);
      
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final encrypted = Encrypted(encryptedBytes);
      return Uint8List.fromList(encrypter.decryptBytes(encrypted, iv: iv));
    } catch (e) {
      print('Decryption error: $e');
      rethrow;
    }
  }
} 