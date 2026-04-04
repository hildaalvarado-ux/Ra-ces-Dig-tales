import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAndSaveImage(String subDir, {ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
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

  static Future<String?> pickAndSaveImageFromFiles(String subDir) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;

      if (kIsWeb) {
        if (file.bytes == null) return null;
        final ext = file.extension ?? 'png';
        return 'data:image/$ext;base64,${base64Encode(file.bytes!)}';
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = p.join(directory.path, subDir);
        final dir = Directory(path);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        final fileName = '${const Uuid().v4()}.${file.extension ?? 'png'}';
        final savedPath = p.join(path, fileName);

        if (file.path != null) {
          await File(file.path!).copy(savedPath);
        } else if (file.bytes != null) {
          await File(savedPath).writeAsBytes(file.bytes!);
        } else {
          return null;
        }

        return savedPath;
      }
    } catch (e) {
      debugPrint('Error picking image from files: $e');
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

  static Future<void> deleteImage(String? path) async {
    if (path == null || path.isEmpty) return;
    if (kIsWeb) return; // Images are stored as base64 in the database on Web

    try {
      // Don't try to delete data URIs (base64)
      if (path.startsWith('data:image')) return;

      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Image deleted: $path');
      }
    } catch (e) {
      debugPrint('Error deleting image at $path: $e');
    }
  }

  static Uint8List? dataUriToBytes(String dataUri) {
    try {
      final parts = dataUri.split(',');
      if (parts.length < 2) return null;
      return base64Decode(parts[1]);
    } catch (e) {
      debugPrint('Error decoding data URI: $e');
      return null;
    }
  }
}
