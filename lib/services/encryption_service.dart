import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class EncryptionService {
  static encrypt.IV _generateIV(String customKey) {
    // Generate a deterministic IV based on the custom key
    final keyHash = sha256.convert(utf8.encode(customKey)).bytes;
    return encrypt.IV(Uint8List.fromList(keyHash.sublist(0, 16)));
  }

  static encrypt.Key _generateKey(String customKey) {
    // Generate a 256-bit key from the custom key using SHA-256
    final keyHash = sha256.convert(utf8.encode(customKey)).bytes;
    return encrypt.Key(Uint8List.fromList(keyHash));
  }

  static Future<Uint8List> encryptBytes(Uint8List bytes, String customKey) async {
    try {
      return await compute(_encryptInIsolate, {
        'bytes': bytes,
        'customKey': customKey,
      });
    } catch (e) {
      print('Encryption error: $e');
      rethrow;
    }
  }

  static Future<Uint8List> decryptBytes(Uint8List encryptedBytes, String customKey) async {
    try {
      return await compute(_decryptInIsolate, {
        'encryptedBytes': encryptedBytes,
        'customKey': customKey,
      });
    } catch (e) {
      print('Decryption error: $e');
      rethrow;
    }
  }

  static Uint8List _encryptInIsolate(Map<String, dynamic> params) {
    final bytes = params['bytes'] as Uint8List;
    final customKey = params['customKey'] as String;
    
    final key = _generateKey(customKey);
    final iv = _generateIV(customKey);
    
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));
    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    return encrypted.bytes;
  }

  static Uint8List _decryptInIsolate(Map<String, dynamic> params) {
    final encryptedBytes = params['encryptedBytes'] as Uint8List;
    final customKey = params['customKey'] as String;
    
    final key = _generateKey(customKey);
    final iv = _generateIV(customKey);
    
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));
    final encrypted = encrypt.Encrypted(encryptedBytes);
    return Uint8List.fromList(encrypter.decryptBytes(encrypted, iv: iv));
  }
} 