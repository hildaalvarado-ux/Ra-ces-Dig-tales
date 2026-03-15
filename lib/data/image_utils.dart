import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAndSaveImage(String subDir) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;

      if (kIsWeb) {
        // En Web, guardamos como data-url (base64)
        final bytes = await image.readAsBytes();
        final ext = p.extension(image.path).replaceAll('.', '');
        return 'data:image/$ext;base64,${base64Encode(bytes)}';
      } else {
        // En Android/iOS, guardamos en el directorio de la app
        final directory = await getApplicationDocumentsDirectory();
        final path = p.join(directory.path, subDir);
        final dir = Directory(path);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        final fileName = '${const Uuid().v4()}${p.extension(image.path)}';
        final savedImage = await File(image.path).copy(p.join(path, fileName));
        return savedImage.path;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  static Future<String?> saveImageBytes(Uint8List bytes, String subDir, String extension) async {
    try {
      if (kIsWeb) {
        final ext = extension.replaceAll('.', '');
        return 'data:image/$ext;base64,${base64Encode(bytes)}';
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = p.join(directory.path, subDir);
        final dir = Directory(path);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        final fileName = '${const Uuid().v4()}.$extension';
        final file = File(p.join(path, fileName));
        await file.writeAsBytes(bytes);
        return file.path;
      }
    } catch (e) {
      debugPrint('Error saving image bytes: $e');
      return null;
    }
  }
}
