// lib/utils/file_utils.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:media_store_plus/media_store_plus.dart';

class FileUtils {
  static final _mediaStore = MediaStore();
  static bool _isMediaStoreInitialized = false;
  static const String APP_FOLDER = "Hafiyyat";
  
  // Initialize MediaStore if not already initialized
  static Future<void> _initializeMediaStore() async {
    if (!_isMediaStoreInitialized) {
      try {
        print('MediaStore başlatılıyor...');
        // Set app folder before initialization
        MediaStore.appFolder = APP_FOLDER;
        await MediaStore.ensureInitialized();
        _isMediaStoreInitialized = true;
        print('MediaStore başarıyla başlatıldı');
      } catch (e) {
        print('MediaStore başlatma hatası: $e');
        throw Exception('MediaStore başlatılamadı: $e');
      }
    }
  }
  
  // Save image to gallery using MediaStore API
  static Future<String> saveImageToGallery(File sourceFile, String filename) async {
    try {
      print('Dosya kaydetme başlatılıyor...');
      print('Kaynak dosya: ${sourceFile.path}');
      print('Hedef dosya adı: $filename');

      // Check if source file exists and get its size
      if (!await sourceFile.exists()) {
        throw Exception('Kaynak dosya bulunamadı: ${sourceFile.path}');
      }
      
      final fileSize = await sourceFile.length();
      print('Dosya boyutu: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      if (Platform.isAndroid) {
        print('Android için MediaStore API kullanılıyor...');
        
        // Initialize MediaStore
        await _initializeMediaStore();
        
        // For Android 10 and above, we don't need storage permission
        final permissionStatus = await Permission.storage.request();
        print('Depolama izni durumu: ${permissionStatus.toString()}');
        
        if (permissionStatus.isGranted) {
          print('MediaStore kayıt isteği oluşturuldu');
          print('Hedef dizin: Pictures/$APP_FOLDER');

          // Create a temporary copy with the final filename
          final tempDir = await getTemporaryDirectory();
          final tempFile = await sourceFile.copy('${tempDir.path}/$filename');
          
          // Save the file using MediaStore
          try {
            // Make sure app folder is set
            MediaStore.appFolder = APP_FOLDER;
            
            final result = await _mediaStore.saveFile(
              tempFilePath: tempFile.path,
              dirType: DirType.photo,
              dirName: DirName.pictures,
              relativePath: APP_FOLDER
            );
            
            // Clean up the temporary file
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
            
            if (result == null) {
              throw Exception('MediaStore kaydetme başarısız - null sonuç');
            }
            
            print('Dosya başarıyla kaydedildi: ${result.uri}');
            return result.uri.toString();
          } catch (e) {
            // Clean up the temporary file in case of error
            if (await tempFile.exists()) {
              await tempFile.delete();
            }
            print('MediaStore kaydetme hatası: $e');
            throw Exception('MediaStore kaydetme hatası: $e');
          }
        } else {
          print('Depolama izni reddedildi');
          throw Exception('Depolama izni verilmedi. İzin durumu: $permissionStatus');
        }
      } else {
        print('iOS/diğer platformlar için belge dizini kullanılıyor...');
        
        // For iOS and other platforms, use documents directory
        final docDir = await getApplicationDocumentsDirectory();
        final targetPath = '${docDir.path}/$filename';
        
        print('Hedef dizin: ${docDir.path}');
        
        // Copy file with error handling
        try {
          final savedFile = await sourceFile.copy(targetPath);
          
          if (!await savedFile.exists()) {
            throw Exception('Dosya kopyalandı fakat hedef dosya bulunamadı');
          }
          
          final savedSize = await savedFile.length();
          print('Kaydedilen dosya boyutu: ${(savedSize / 1024).toStringAsFixed(2)} KB');
          print('Dosya başarıyla kaydedildi: ${savedFile.path}');
          
          return savedFile.path;
        } catch (e) {
          print('Dosya kopyalama hatası: $e');
          throw Exception('Dosya kopyalama hatası: $e');
        }
      }
    } catch (e) {
      print('Dosya kaydetme hatası detayı: $e'); // Detailed logging
      throw Exception('Dosya kaydetme hatası: ${e.toString()}');
    }
  }
  
  // Clean up temporary files
  static Future<void> cleanupTempFiles() async {
    try {
      print('Geçici dosyaları temizleme başlatılıyor...');
      
      final tempDir = await getTemporaryDirectory();
      if (!await tempDir.exists()) {
        print('Geçici dizin bulunamadı: ${tempDir.path}');
        return;
      }
      
      print('Geçici dizin: ${tempDir.path}');
      
      final files = tempDir.listSync();
      print('Toplam dosya sayısı: ${files.length}');
      
      int deletedCount = 0;
      int errorCount = 0;
      
      for (var entity in files) {
        if (entity is File && 
            (entity.path.contains('stego_result_') || 
             entity.path.contains('extracted_image_') ||
             entity.path.contains('hafiyyat_'))) {
          try {
            await entity.delete();
            deletedCount++;
            print('Silinen dosya: ${entity.path}');
          } catch (e) {
            errorCount++;
            print('Dosya silme hatası: ${entity.path} - $e');
            continue;
          }
        }
      }
      
      print('Temizleme tamamlandı:');
      print('- Silinen dosya sayısı: $deletedCount');
      print('- Hatalı silme sayısı: $errorCount');
    } catch (e) {
      print('Geçici dosyaları temizleme hatası: $e');
      // Don't throw here as this is a cleanup operation
    }
  }
}