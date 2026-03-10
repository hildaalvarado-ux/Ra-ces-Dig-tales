import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'help_dialogs.dart';

class Cultivo {
  final String nombre;
  final String imagen; // ruta del asset
  final String cientifico;
  final int cosechaMeses;
  final String tipo;
  final String estacion;
  final String identificacion;
  final String siembra;
  final Map<String, String> ficha;
  final List<String> plagas;

  const Cultivo({
    required this.nombre,
    required this.imagen,
    required this.cientifico,
    required this.cosechaMeses,
    required this.tipo,
    required this.estacion,
    required this.identificacion,
    required this.siembra,
    required this.ficha,
    required this.plagas,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'imagen': imagen,
        'cientifico': cientifico,
        'cosechaMeses': cosechaMeses,
        'tipo': tipo,
        'estacion': estacion,
        'identificacion': identificacion,
        'siembra': siembra,
        'ficha': ficha,
        'plagas': plagas,
      };

  static Cultivo fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    final plagas = (j['plagas'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    return Cultivo(
      nombre: (j['nombre'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      cientifico: (j['cientifico'] ?? '').toString(),
      cosechaMeses: (j['cosechaMeses'] ?? 0) is int ? (j['cosechaMeses'] as int) : int.tryParse('${j['cosechaMeses']}') ?? 0,
      tipo: (j['tipo'] ?? '').toString(),
      estacion: (j['estacion'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      siembra: (j['siembra'] ?? '').toString(),
      ficha: ficha,
      plagas: plagas,
    );
  }
}

class CultivoDetallePage extends StatelessWidget {
  final Cultivo cultivo;
  const CultivoDetallePage({super.key, required this.cultivo});

  Future<void> _copyForWhatsApp(BuildContext context) async {
    final text = const JsonEncoder.withIndent('  ').convert(cultivo.toJson());
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Copiado. Pega este texto en WhatsApp para compartirlo.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(cultivo.nombre, style: const TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              tooltip: 'Compartir (WhatsApp)',
              onPressed: () => _copyForWhatsApp(context),
              icon: const Icon(Icons.share_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            children: [
              Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.82),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        cultivo.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image_not_supported_rounded, size: 42),
        ),
      ),
    ),
  ),
),
const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Identificación',
                      onHelp: () => HelpDialogs.show(
                        context,
                        title: 'Identificación',
                        text: 'Descripción breve para reconocer el cultivo.',
                      ),
                    ),
                    Text(
                      cultivo.identificacion,
                      style: TextStyle(
                        color: AppColors.greenDarker.withOpacity(0.86),
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Siembra',
                      onHelp: () => HelpDialogs.show(
                        context,
                        title: 'Siembra',
                        text: 'Consejos básicos para sembrar este cultivo.',
                      ),
                    ),
                    Text(
                      cultivo.siembra,
                      style: TextStyle(
                        color: AppColors.greenDarker.withOpacity(0.86),
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Ficha rápida',
                      onHelp: () => HelpDialogs.show(
                        context,
                        title: 'Ficha rápida',
                        text: 'Datos clave como distancia, profundidad, clima y riego.',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...cultivo.ficha.entries.map(
                      (e) => _InfoRow(
                        label: e.key,
                        value: e.value,
                        onHelp: () => HelpDialogs.show(
                          context,
                          title: e.key,
                          text: HelpDialogs.textForField(e.key),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderRow(
                      title: 'Plagas',
                      onHelp: () => HelpDialogs.show(
                        context,
                        title: 'Plagas',
                        text: 'Plagas comunes que pueden afectar este cultivo.',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: cultivo.plagas
                          .map(
                            (p) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.greenDark.withOpacity(0.14)),
                              ),
                              child: Text(
                                p,
                                style: const TextStyle(
                                  color: AppColors.greenDarker,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
      ),
      child: child,
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback onHelp;
  const _HeaderRow({required this.title, required this.onHelp});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.greenDarker,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: '¿Qué significa?',
          onPressed: onHelp,
          icon: const Icon(Icons.help_outline_rounded),
          color: AppColors.greenDarker,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onHelp;

  const _InfoRow({required this.label, required this.value, required this.onHelp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label\n$value',
              style: const TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
          IconButton(
            onPressed: onHelp,
            icon: const Icon(Icons.help_outline_rounded),
            color: AppColors.greenDarker,
          ),
        ],
      ),
    );
  }
}