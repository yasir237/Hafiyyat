import 'package:flutter/material.dart';

class EncryptionKeyDialog extends StatefulWidget {
  final bool isEncoding;

  const EncryptionKeyDialog({
    Key? key,
    required this.isEncoding,
  }) : super(key: key);

  @override
  _EncryptionKeyDialogState createState() => _EncryptionKeyDialogState();
}

class _EncryptionKeyDialogState extends State<EncryptionKeyDialog> {
  final TextEditingController _keyController = TextEditingController();
  bool _useEncryption = false;
  bool _showKey = false;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF112240),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isEncoding ? 'Şifreleme Anahtarı' : 'Çözme Anahtarı',
                style: const TextStyle(
                  color: Color(0xFFCCD6F6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (widget.isEncoding)
                SwitchListTile(
                  title: const Text(
                    'Şifreleme Kullan',
                    style: TextStyle(
                      color: Color(0xFFCCD6F6),
                      fontSize: 16,
                    ),
                  ),
                  value: _useEncryption,
                  onChanged: (value) {
                    setState(() {
                      _useEncryption = value;
                      if (!value) {
                        _keyController.clear();
                      }
                    });
                  },
                  activeColor: const Color(0xFF64FFDA),
                ),
              if (!widget.isEncoding || _useEncryption)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _keyController,
                    obscureText: !_showKey,
                    enabled: widget.isEncoding ? _useEncryption : true,
                    style: const TextStyle(color: Color(0xFFCCD6F6)),
                    decoration: InputDecoration(
                      hintText: 'Anahtarı girin',
                      hintStyle: TextStyle(
                        color: const Color(0xFFCCD6F6).withOpacity(0.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF64FFDA)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF64FFDA), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showKey ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF64FFDA),
                        ),
                        onPressed: () {
                          setState(() {
                            _showKey = !_showKey;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              if (!widget.isEncoding)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Not: Görüntü şifreliyse doğru anahtarı girmelisiniz.',
                    style: TextStyle(
                      color: Color(0xFFCCD6F6),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final key = _useEncryption || !widget.isEncoding 
                          ? _keyController.text.trim()
                          : null;
                      Navigator.of(context).pop(key);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64FFDA),
                      foregroundColor: const Color(0xFF112240),
                      minimumSize: const Size(120, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Devam',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 