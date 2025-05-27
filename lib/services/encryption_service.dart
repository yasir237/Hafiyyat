import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final key = Key.fromSecureRandom(32); // 256 bit
  static final iv = IV.fromSecureRandom(16);   // 128 bit

  static Uint8List encryptBytes(Uint8List bytes) {
    try {
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final encrypted = encrypter.encryptBytes(bytes, iv: iv);
      return encrypted.bytes;
    } catch (e) {
      print('Encryption error: $e');
      rethrow;
    }
  }

  static Uint8List decryptBytes(Uint8List encryptedBytes) {
    try {
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final encrypted = Encrypted(encryptedBytes);
      return Uint8List.fromList(encrypter.decryptBytes(encrypted, iv: iv));
    } catch (e) {
      print('Decryption error: $e');
      rethrow;
    }
  }
} 