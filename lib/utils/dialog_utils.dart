import 'package:flutter/material.dart';
import 'package:hafiyyat/widgets/encryption_key_dialog.dart';

class DialogUtils {
  static Future<String?> showEncryptionKeyDialog(
    BuildContext context, {
    required bool isEncoding,
  }) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EncryptionKeyDialog(isEncoding: isEncoding);
      },
    );
  }
} 