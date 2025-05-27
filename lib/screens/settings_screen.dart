import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hafiyyat/widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Siber güvenlik renk teması
  static const Color _backgroundColor = Color(0xFF0A192F);
  static const Color _accentColor = Color(0xFF64FFDA);
  static const Color _surfaceColor = Color(0xFF112240);
  static const Color _textColor = Color(0xFFCCD6F6);

  // Ayarlar
  bool _autoSaveEnabled = true;
  bool _highQualityEnabled = true;
  bool _autoCleanupEnabled = false;
  String _saveLocation = 'DCIM/Hafiyyat';
  bool _isCalculatingSize = false;
  String _cacheSize = '0 MB';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _calculateCacheSize();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoSaveEnabled = prefs.getBool('autoSave') ?? true;
      _highQualityEnabled = prefs.getBool('highQuality') ?? true;
      _autoCleanupEnabled = prefs.getBool('autoCleanup') ?? false;
      _saveLocation = prefs.getString('saveLocation') ?? 'DCIM/Hafiyyat';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoSave', _autoSaveEnabled);
    await prefs.setBool('highQuality', _highQualityEnabled);
    await prefs.setBool('autoCleanup', _autoCleanupEnabled);
    await prefs.setString('saveLocation', _saveLocation);
  }

  Future<void> _calculateCacheSize() async {
    setState(() => _isCalculatingSize = true);
    try {
      final tempDir = await getTemporaryDirectory();
      int totalSize = 0;
      
      await for (var entity in tempDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      
      setState(() {
        _cacheSize = '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
      });
    } catch (e) {
      setState(() {
        _cacheSize = 'Hesaplanamadı';
      });
    }
    setState(() => _isCalculatingSize = false);
  }

  Future<void> _clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      await tempDir.delete(recursive: true);
      await tempDir.create();
      await _calculateCacheSize();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önbellek temizlendi'),
          backgroundColor: _surfaceColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önbellek temizlenirken hata oluştu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: const CustomAppBar(title: 'AYARLAR'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Kaydetme Ayarları'),
            _buildSettingSwitch(
              'Otomatik Kaydetme',
              'İşlem tamamlandığında görüntüyü otomatik kaydet',
              _autoSaveEnabled,
              (value) {
                setState(() => _autoSaveEnabled = value);
                _saveSettings();
              },
            ),
            _buildSettingSwitch(
              'Yüksek Kalite',
              'Görüntüleri en yüksek kalitede kaydet (daha büyük dosya)',
              _highQualityEnabled,
              (value) {
                setState(() => _highQualityEnabled = value);
                _saveSettings();
              },
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Depolama'),
            _buildSettingTile(
              'Kayıt Konumu',
              _saveLocation,
              icon: Icons.folder_outlined,
              onTap: () {
                // Konum seçme dialogu gösterilecek
              },
            ),
            _buildSettingTile(
              'Önbellek Boyutu',
              _isCalculatingSize ? 'Hesaplanıyor...' : _cacheSize,
              icon: Icons.storage_outlined,
              onTap: _calculateCacheSize,
            ),
            const SizedBox(height: 8),
            _buildOutlinedButton(
              'Önbelleği Temizle',
              Icons.cleaning_services_outlined,
              _clearCache,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Otomatik Temizleme'),
            _buildSettingSwitch(
              'Otomatik Temizleme',
              'Eski geçici dosyaları otomatik olarak temizle',
              _autoCleanupEnabled,
              (value) {
                setState(() => _autoCleanupEnabled = value);
                _saveSettings();
              },
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Uygulama Hakkında'),
            _buildSettingTile(
              'Versiyon',
              '1.2.0',
              icon: Icons.info_outline,
            ),
            _buildSettingTile(
              'Geliştirici',
              'Yasir Alrawi',
              icon: Icons.code,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: _accentColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentColor.withOpacity(0.3)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: _textColor.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: _accentColor,
        inactiveThumbColor: _textColor.withOpacity(0.3),
        inactiveTrackColor: _textColor.withOpacity(0.1),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle, {
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentColor.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: icon != null
            ? Icon(
                icon,
                color: _accentColor,
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: _textColor.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
        onTap: onTap,
        trailing: onTap != null
            ? Icon(
                Icons.chevron_right,
                color: _accentColor.withOpacity(0.7),
              )
            : null,
      ),
    );
  }

  Widget _buildOutlinedButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          foregroundColor: _accentColor,
          side: const BorderSide(color: _accentColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon),
        label: Text(title),
      ),
    );
  }
} 