import 'dart:convert';

class Cultivo {
  final int? id; // null si es del catálogo
  final String nombre;
  final String imagen; // ruta del asset
  final String? imagePath; // ruta del archivo local o base64 (web)
  final String cientifico;
  final int cosechaMeses;
  final String tipo;
  final String estacion;
  final String identificacion;
  final String siembra;
  final Map<String, String> ficha;
  final List<String> plagas;
  final List<String> beneficiosos;
  final List<String> perjudiciales;
  final Map<String, dynamic>? guiaRapida;

  const Cultivo({
    this.id,
    required this.nombre,
    required this.imagen,
    this.imagePath,
    required this.cientifico,
    required this.cosechaMeses,
    required this.tipo,
    required this.estacion,
    required this.identificacion,
    required this.siembra,
    required this.ficha,
    required this.plagas,
    this.beneficiosos = const [],
    this.perjudiciales = const [],
    this.guiaRapida,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'imagen': imagen,
        if (imagePath != null) 'imagePath': imagePath,
        'cientifico': cientifico,
        'cosechaMeses': cosechaMeses,
        'tipo': tipo,
        'estacion': estacion,
        'identificacion': identificacion,
        'siembra': siembra,
        'ficha': ficha,
        'insectos': plagas,
        'beneficiosos': beneficiosos,
        'perjudiciales': perjudiciales,
        if (guiaRapida != null) 'guiaRapida': guiaRapida,
      };

  static Cultivo fromJson(Map<String, dynamic> j) {
    final ficha = (j['ficha'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        <String, String>{};

    final plagas = (j['insectos'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final ben = (j['beneficiosos'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final per = (j['perjudiciales'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final guia = j['guiaRapida'] as Map<String, dynamic>?;

    return Cultivo(
      id: j['id'] as int?,
      nombre: (j['nombre'] ?? '').toString(),
      imagen: (j['imagen'] ?? '').toString(),
      imagePath: (j['imagePath'] ?? j['image_path'])?.toString(),
      cientifico: (j['cientifico'] ?? '').toString(),
      cosechaMeses: (j['cosechaMeses'] ?? 0) is int
          ? (j['cosechaMeses'] as int)
          : int.tryParse('${j['cosechaMeses']}') ?? 0,
      tipo: (j['tipo'] ?? '').toString(),
      estacion: (j['estacion'] ?? '').toString(),
      identificacion: (j['identificacion'] ?? '').toString(),
      siembra: (j['siembra'] ?? '').toString(),
      ficha: ficha,
      plagas: plagas,
      beneficiosos: ben,
      perjudiciales: per,
      guiaRapida: guia,
    );
  }
}
