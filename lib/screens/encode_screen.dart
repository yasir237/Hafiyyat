// lib/screens/encode_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hafiyyat/services/steganography_service.dart';
import 'package:hafiyyat/widgets/loading_overlay.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:hafiyyat/utils/file_utils.dart';
import 'package:hafiyyat/widgets/custom_app_bar.dart';
import 'package:hafiyyat/utils/dialog_utils.dart';

class EncodeScreen extends StatefulWidget {
  const EncodeScreen({super.key});

  @override
  _EncodeScreenState createState() => _EncodeScreenState();
}

class _EncodeScreenState extends State<EncodeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _coverImage; // Renkli görüntü (gizleyecek olan)
  File? _secretImage; // (gizlenecek olan)
  bool _isProcessing = false;
  File? _resultImage;
  String? _progressText;

  // Siber güvenlik renk teması
  static const Color _backgroundColor = Color(0xFF0A192F); // Koyu lacivert
  static const Color _accentColor = Color(0xFF64FFDA); // Siber yeşili
  static const Color _surfaceColor = Color(0xFF112240); // Orta lacivert
  static const Color _textColor = Color(0xFFCCD6F6); // Açık gri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: const CustomAppBar(title: 'GÖRÜNTÜ GİZLE'),
      body: LoadingOverlay(
        isLoading: _isProcessing,
        loadingText: 'Görüntü işleniyor...',
        loadingTextColor: _accentColor,
        progressText: _progressText,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, MediaQuery.of(context).padding.bottom + 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageSelectionSection(
                title: 'Kapsayıcı Renkli Görüntü',
                image: _coverImage,
                onSelectImage: _selectCoverImage,
                iconData: Icons.image,
              ),
              const SizedBox(height: 24),
              _buildImageSelectionSection(
                title: 'Gizlenecek Görüntü',
                image: _secretImage,
                onSelectImage: _selectSecretImage,
                iconData: Icons.image_search,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: (_coverImage != null &&
                        _secretImage != null &&
                        !_isProcessing)
                    ? _startEncoding
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
                  'GÖRÜNTÜYÜ GİZLE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              if (_resultImage != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Sonuç:',
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
                      _resultImage!,
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
                        onPressed: _shareResultImage,
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
                        onPressed: _saveResultImage,
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

  Widget _buildImageSelectionSection({
    required String title,
    required File? image,
    required Function() onSelectImage,
    required IconData iconData,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _accentColor,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onSelectImage,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accentColor.withOpacity(0.3)),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        size: 64,
                        color: _accentColor.withOpacity(0.7),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Görüntü seçmek için tıklayın',
                        style: TextStyle(
                          color: _textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectCoverImage() async {
    if (_isProcessing) return; // Prevent multiple calls while processing

    try {
      setState(() {
        _isProcessing = true;
      });
      
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _coverImage = File(image.path);
          _resultImage = null; // Reset result when new image selected
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

  Future<void> _selectSecretImage() async {
    if (_isProcessing) return; // Prevent multiple calls while processing

    try {
      setState(() {
        _isProcessing = true;
      });
      
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _secretImage = File(image.path);
          _resultImage = null; // Reset result when new image selected
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

  Future<void> _startEncoding() async {
    if (_coverImage == null || _secretImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen gerekli görüntüleri seçin')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _progressText = 'Hazırlanıyor...';
    });

    try {
      setState(() => _progressText = 'Şifreleme ayarları kontrol ediliyor...');
      final encryptionKey = await DialogUtils.showEncryptionKeyDialog(
        context,
        isEncoding: true,
      );

      setState(() => _progressText = 'Görüntüler işleniyor...');
      final stegoService = SteganographyService();
      
      setState(() => _progressText = encryptionKey != null 
        ? 'Görüntü şifreleniyor ve gizleniyor...'
        : 'Görüntü gizleniyor...');
      
      final resultPath = await stegoService.encodeImage(
        coverImagePath: _coverImage!.path,
        secretImagePath: _secretImage!.path,
        encryptionKey: encryptionKey,
      );

      setState(() {
        _resultImage = File(resultPath);
        _progressText = 'Tamamlandı!';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            encryptionKey != null
                ? 'Görüntü şifrelenerek gizlendi'
                : 'Görüntü başarıyla gizlendi'
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _progressText = null;
        });
      }
    }
  }

  Future<void> _shareResultImage() async {
    if (_resultImage != null) {
      await Share.shareXFiles([XFile(_resultImage!.path)],
          text: 'hafiyyat ile oluşturuldu');
    }
  }

  Future<void> _saveResultImage() async {
    if (_resultImage == null) return;

    try {
      final String fileName = 'hafiyyat_${DateTime.now().millisecondsSinceEpoch}.png';
      final String savedPath = await FileUtils.saveImageToGallery(_resultImage!, fileName);
      
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
