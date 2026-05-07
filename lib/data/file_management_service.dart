import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class FileManagementService {
  static const String rootFolder = 'RaicesDigitales';

  static const Map<String, String> moduleFolders = {
    'cultivo': 'Cultivos',
    'fertilizante': 'Fertilizantes',
    'pesticida': 'Repelentes',
    'plaga': 'Insectos',
    'enfermedad': 'Enfermedades',
    'compartido': 'Compartidos',
  };

  /// Solicita permisos de almacenamiento según la versión de Android.
  Future<bool> _requestPermissions() async {
    if (kIsWeb) return true;

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // En Android 13+, pedimos permisos para fotos/videos si se necesitan,
        // pero para guardar archivos en Descargas usualmente no se requiere permiso explicito
        // si se usa el MediaStore o Scoped Storage.
        // Sin embargo, para simplicidad con File API:
        final photos = await Permission.photos.request();
        return photos.isGranted;
      } else {
        // Android 12 y anteriores
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      // En iOS usualmente no se requiere permiso para escribir en la carpeta de documentos de la app
      return true;
    }
    return true;
  }

  Future<String?> getExternalRootPath() async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        // Intentamos obtener la ruta de la carpeta pública de Descargas para persistencia
        // path_provider no da la ruta raíz directamente, pero podemos usargetExternalStorageDirectory
        // y manipular la cadena, o usar una ruta común.
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          // extDir suele ser /storage/emulated/0/Android/data/com.example.../files
          // Queremos subir niveles hasta /storage/emulated/0/Download
          final parts = extDir.path.split('/');
          final androidIndex = parts.indexOf('Android');
          if (androidIndex != -1) {
            final publicPath = parts.sublist(0, androidIndex).join('/');
            directory = Directory(p.join(publicPath, 'Download'));
          } else {
            directory = await getDownloadsDirectory() ?? extDir;
          }
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) return null;

      final path = p.join(directory.path, rootFolder);
      final dir = Directory(path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return path;
    } catch (e) {
      debugPrint('Error getting external root path: $e');
      return null;
    }
  }

  Future<String?> getModulePath(String module) async {
    final root = await getExternalRootPath();
    if (root == null) return null;

    final folderName = moduleFolders[module] ?? module;
    final path = p.join(root, folderName);
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path;
  }

  Future<String?> _prepareImageData(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('data:image')) return imagePath;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final ext = p.extension(imagePath).replaceAll('.', '');
        final mime = ext.isEmpty ? 'png' : ext;
        return 'data:image/$mime;base64,${base64Encode(bytes)}';
      }
    } catch (e) {
      debugPrint('Error preparing image data: $e');
    }
    return null;
  }

  /// Guarda la información en un archivo JSON en la carpeta correspondiente.
  Future<String?> saveModuleData({
    required String module,
    required String name,
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    try {
      if (!await _requestPermissions()) return null;

      final modulePath = await getModulePath(module);
      if (modulePath == null) return null;

      final Map<String, dynamic> exportData = Map.from(data);
      exportData['image_exported'] = await _prepareImageData(imagePath);

      final fileName = '${name.replaceAll(' ', '_').toLowerCase()}.rdc';
      final filePath = p.join(modulePath, fileName);
      final file = File(filePath);

      await file.writeAsString(jsonEncode(exportData));

      final folderName = moduleFolders[module] ?? module;
      return '$rootFolder/$folderName/$fileName';
    } catch (e) {
      debugPrint('Error saving module data: $e');
      return null;
    }
  }

  /// Comparte la información.
  Future<void> shareModuleData({
    required String module,
    required String name,
    required Map<String, dynamic> data,
    String? imagePath,
    String? text,
  }) async {
    try {
      // Para compartir siempre intentamos usar un archivo temporal en cache
      final tempDir = await getTemporaryDirectory();
      final fileName = '${name.replaceAll(' ', '_').toLowerCase()}.rdc';
      final filePath = p.join(tempDir.path, fileName);
      final file = File(filePath);

      final Map<String, dynamic> exportData = Map.from(data);
      exportData['image_exported'] = await _prepareImageData(imagePath);

      await file.writeAsString(jsonEncode(exportData));

      await Share.shareXFiles(
        [XFile(file.path)],
        text: text ?? 'Mira mi ${moduleFolders[module] ?? module}: $name',
      );
    } catch (e) {
      debugPrint('Error sharing module data: $e');
      // Fallback a texto si algo falla
      await Share.share(text ?? 'Mira mi ${moduleFolders[module] ?? module}: $name');
    }
  }
}

final fileManagementService = FileManagementService();
