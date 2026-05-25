import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../main.dart';
import '../data/db_instance.dart';
import '../data/image_utils.dart';

class RendimientoPage extends StatefulWidget {
  final int userId;
  const RendimientoPage({super.key, required this.userId});

  @override
  State<RendimientoPage> createState() => _RendimientoPageState();
}

class _RendimientoPageState extends State<RendimientoPage> {
  bool _isLoading = false;
  String _dbSize = 'Calculando...';
  String _imagesSize = 'Calculando...';

  @override
  void initState() {
    super.initState();
    _calculateStorage();
  }

  Future<void> _calculateStorage() async {
    setState(() {
      _dbSize = 'Calculando...';
      _imagesSize = 'Calculando...';
    });

    if (kIsWeb) {
      setState(() {
        _dbSize = 'No disponible en Web';
        _imagesSize = 'No disponible en Web';
      });
      return;
    }

    try {
      final docDir = await getApplicationDocumentsDirectory();

      // DB Size
      final dbFile = File('${docDir.path}/raices.sqlite');
      if (await dbFile.exists()) {
        final stat = await dbFile.stat();
        _dbSize = _formatBytes(stat.size);
      } else {
        _dbSize = '0 B';
      }

      // Images Size
      double totalSize = 0;
      final dirs = ['cultivo_images', 'fertilizante_images', 'plaga_images', 'pesticida_images', 'observation_images', 'user_avatars'];

      for (final dirName in dirs) {
        final dir = Directory('${docDir.path}/$dirName');
        if (await dir.exists()) {
          await for (final file in dir.list(recursive: true, followLinks: false)) {
            if (file is File) {
              totalSize += await file.length();
            }
          }
        }
      }
      _imagesSize = _formatBytes(totalSize.toInt());

    } catch (e) {
      debugPrint('Error calculando almacenamiento: $e');
      _dbSize = 'Error';
      _imagesSize = 'Error';
    }

    if (mounted) setState(() {});
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    double sizeDouble = bytes.toDouble();
    int unitIndex = 0;
    while (sizeDouble >= 1024 && unitIndex < suffixes.length - 1) {
      sizeDouble /= 1024;
      unitIndex++;
    }
    return "${sizeDouble.toStringAsFixed(2)} ${suffixes[unitIndex]}";
  }

  Future<void> _optimize() async {
    setState(() => _isLoading = true);
    try {
      final count = await appDb.optimizeData(widget.userId);
      await _calculateStorage();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Optimización completada. Se eliminaron $count registros innecesarios.'),
            backgroundColor: AppColors.greenDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al optimizar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Limpiar todos los datos?'),
        content: const Text('Esta acción eliminará todos tus cultivos, planes, tareas y fotos. No se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('LIMPIAR TODO'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      // 1. Delete local images
      if (!kIsWeb) {
        final imagePaths = await appDb.getAllUserImagePaths(widget.userId);
        for (final path in imagePaths) {
          await ImageUtils.deleteImage(path);
        }
      }

      // 2. Clear database tables
      await appDb.deleteAllUserData(widget.userId);

      await _calculateStorage();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todos los datos han sido eliminados correctamente.'),
            backgroundColor: AppColors.greenDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al limpiar datos: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Rendimiento', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado del Sistema',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.greenDarker),
                  ),
                  const SizedBox(height: 20),

                  _UsageCard(
                    title: 'Base de Datos',
                    value: _dbSize,
                    icon: Icons.storage_rounded,
                    color: Colors.blue,
                    subtitle: kIsWeb ? 'El navegador gestiona el almacenamiento automáticamente' : null,
                  ),
                  const SizedBox(height: 12),
                  _UsageCard(
                    title: 'Imágenes y Archivos',
                    value: _imagesSize,
                    icon: Icons.image_rounded,
                    color: Colors.orange,
                    subtitle: kIsWeb ? 'Las imágenes se guardan como datos locales en el navegador' : null,
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Acciones de Mantenimiento',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.greenDarker),
                  ),
                  const SizedBox(height: 16),

                  _ActionCard(
                    title: 'Optimizar aplicación',
                    description: 'Elimina registros antiguos, notificaciones leídas y tareas huérfanas para mejorar la velocidad.',
                    icon: Icons.speed_rounded,
                    buttonLabel: 'OPTIMIZAR AHORA',
                    onTap: _optimize,
                  ),
                  const SizedBox(height: 16),
                  _ActionCard(
                    title: 'Limpiar datos del huerto',
                    description: 'Elimina permanentemente todos tus cultivos, planes y fotos guardadas.',
                    icon: Icons.delete_forever_rounded,
                    buttonLabel: 'LIMPIAR DATOS',
                    color: Colors.red,
                    onTap: _clearData,
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _UsageCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _UsageCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonLabel;
  final VoidCallback onTap;
  final Color color;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonLabel,
    required this.onTap,
    this.color = AppColors.greenDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1)),
            ),
          ),
        ],
      ),
    );
  }
}
