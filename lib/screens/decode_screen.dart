// lib/screens/decode_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hafiyyat/services/steganography_service.dart';
import 'package:hafiyyat/widgets/loading_overlay.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hafiyyat/utils/file_utils.dart';
import 'package:hafiyyat/widgets/custom_app_bar.dart';
import 'package:hafiyyat/utils/dialog_utils.dart';

class DecodeScreen extends StatefulWidget {
  const DecodeScreen({super.key});

  @override
  _DecodeScreenState createState() => _DecodeScreenState();
}

class _DecodeScreenState extends State<DecodeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _stegoImage; // İçinde gizli görüntü olan resim
  bool _isProcessing = false;
  File? _extractedImage;

  // Siber güvenlik renk teması
  static const Color _backgroundColor = Color(0xFF0A192F); // Koyu lacivert
  static const Color _accentColor = Color(0xFF64FFDA); // Siber yeşili
  static const Color _surfaceColor = Color(0xFF112240); // Orta lacivert
  static const Color _textColor = Color(0xFFCCD6F6); // Açık gri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: const CustomAppBar(title: 'GÖRÜNTÜ ÇIKAR'),
      body: LoadingOverlay(
        isLoading: _isProcessing,
        loadingText: 'Gizli görüntü çıkarılıyor...',
        loadingTextColor: _accentColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, MediaQuery.of(context).padding.bottom + 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Stego Görüntü',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectStegoImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _accentColor.withOpacity(0.3)),
                  ),
                  child: _stegoImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _stegoImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_search,
                              size: 64,
                              color: _accentColor.withOpacity(0.7),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Stego görüntü seçmek için tıklayın',
                              style: TextStyle(
                                color: _textColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: (_stegoImage != null && !_isProcessing)
                    ? _startDecoding
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: _accentColor,
                  foregroundColor: _backgroundColor,
                  disabledBackgroundColor: _accentColor.withOpacity(0.3),
                  disabledForegroundColor: _backgroundColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'GİZLİ GÖRÜNTÜYÜ ÇIKAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              if (_extractedImage != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Çıkarılan Gizli Görüntü:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _accentColor,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _accentColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _extractedImage!,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _shareExtractedImage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          foregroundColor: _accentColor,
                          side: const BorderSide(color: _accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.share),
                        label: const Text(
                          'Paylaş',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saveExtractedImage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          foregroundColor: _accentColor,
                          side: const BorderSide(color: _accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Kaydet',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStegoImage() async {
    if (_isProcessing) return; // Prevent multiple calls while processing

    try {
      setState(() {
        _isProcessing = true;
      });
      
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _stegoImage = File(image.path);
          _extractedImage = null; // Reset result when new image selected
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görüntü seçme hatası: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _startDecoding() async {
    if (_stegoImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir görüntü seçin')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Şifre çözme anahtarını sor
      final decryptionKey = await DialogUtils.showEncryptionKeyDialog(
        context,
        isEncoding: false,
      );

      final stegoService = SteganographyService();
      final resultPath = await stegoService.decodeImage(
        stegoImagePath: _stegoImage!.path,
        encryptionKey: decryptionKey, // Anahtar null olabilir
      );

      setState(() {
        _extractedImage = File(resultPath);
      });

      // Başarılı mesajı göster
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Görüntü başarıyla çıkarıldı'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('decrypt')
                ? 'Hata: Yanlış şifreleme anahtarı veya görüntü şifreli değil'
                : 'Hata: $e'
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _shareExtractedImage() async {
    if (_extractedImage != null) {
      await Share.shareXFiles([XFile(_extractedImage!.path)],
          text: 'hafiyyat ile oluşturuldu');
    }
  }

  Future<void> _saveExtractedImage() async {
    if (_extractedImage == null) return;

    try {
      final String fileName = 'hafiyyat_extracted_${DateTime.now().millisecondsSinceEpoch}.png';
      final String savedPath = await FileUtils.saveImageToGallery(_extractedImage!, fileName);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Görüntü başarıyla kaydedildi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kaydetme başarısız: ${e.toString()}')),
      );
    }
  }
}
