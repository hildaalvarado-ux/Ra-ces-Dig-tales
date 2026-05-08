import 'dart:convert';

class TareaPreparacion {
  final String tipo;
  final String? metodoSeleccionado;
  final int duracionDias;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String estado; // "pendiente", "en_proceso", "completado", "omitido"

  TareaPreparacion({
    required this.tipo,
    this.metodoSeleccionado,
    this.duracionDias = 0,
    this.fechaInicio,
    this.fechaFin,
    this.estado = 'pendiente',
  });

  Map<String, dynamic> toJson() => {
    'tipo': tipo,
    'metodoSeleccionado': metodoSeleccionado,
    'duracionDias': duracionDias,
    'fechaInicio': fechaInicio?.toIso8601String(),
    'fechaFin': fechaFin?.toIso8601String(),
    'estado': estado,
  };

  factory TareaPreparacion.fromJson(Map<String, dynamic> j) => TareaPreparacion(
    tipo: j['tipo'],
    metodoSeleccionado: j['metodoSeleccionado'],
    duracionDias: j['duracionDias'] ?? 0,
    fechaInicio: j['fechaInicio'] != null ? DateTime.parse(j['fechaInicio']) : null,
    fechaFin: j['fechaFin'] != null ? DateTime.parse(j['fechaFin']) : null,
    estado: j['estado'] ?? 'pendiente',
  );

  TareaPreparacion copyWith({
    String? tipo,
    String? metodoSeleccionado,
    int? duracionDias,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? estado,
  }) => TareaPreparacion(
    tipo: tipo ?? this.tipo,
    metodoSeleccionado: metodoSeleccionado ?? this.metodoSeleccionado,
    duracionDias: duracionDias ?? this.duracionDias,
    fechaInicio: (estado == 'omitido' || estado == 'pendiente') ? null : (fechaInicio ?? this.fechaInicio),
    fechaFin: (estado == 'omitido' || estado == 'pendiente') ? null : (fechaFin ?? this.fechaFin),
    estado: estado ?? this.estado,
  );
}

extension TareaPreparacionListExt on List<TareaPreparacion> {
  double get progress {
    if (isEmpty) return 0.0;
    final relevantTasks = where((t) => t.estado != 'omitido').toList();
    if (relevantTasks.isEmpty) return 1.0;
    final completedCount = relevantTasks.where((t) => t.estado == 'completado').length;
    return completedCount / relevantTasks.length;
  }

  String get statusMessage {
    if (isEmpty) return 'Sin tareas';
    final relevantTasks = where((t) => t.estado != 'omitido').toList();
    if (relevantTasks.every((t) => t.estado == 'completado')) return 'Suelo listo';

    final currentTask = firstWhere((t) => t.estado == 'en_proceso',
        orElse: () => firstWhere((t) => t.estado == 'pendiente', orElse: () => last));

    if (currentTask.estado == 'en_proceso') {
      return 'En proceso: ${currentTask.tipo}';
    } else if (currentTask.estado == 'pendiente') {
      return 'Pendiente: ${currentTask.tipo}';
    }
    return 'En proceso';
  }

  String get timeRemainingMessage {
    final relevantTasksWithDate = where((t) => t.estado == 'en_proceso' && t.fechaFin != null).toList();
    if (relevantTasksWithDate.isEmpty) {
      final allFinished = every((t) => t.estado == 'completado' || t.estado == 'omitido');
      if (allFinished) return 'Completado';
      return 'Fecha estimada: Pendiente';
    }

    DateTime? maxDate;
    for (var t in this) {
      if (t.fechaFin != null && (maxDate == null || t.fechaFin!.isAfter(maxDate))) {
        maxDate = t.fechaFin;
      }
    }

    if (maxDate == null) return 'Pendiente';

    final now = DateTime.now();
    final diff = maxDate.difference(now);

    if (diff.isNegative) return 'Listo';

    if (diff.inDays > 0) {
      return 'Listo en ${diff.inDays} ${diff.inDays == 1 ? 'día' : 'días'}';
    } else if (diff.inHours > 0) {
      return 'Listo en ${diff.inHours} ${diff.inHours == 1 ? 'hora' : 'horas'}';
    } else {
      return 'Listo en menos de una hora';
    }
  }
}

class MetodoPreparacion {
  final String nombre;
  final int duracionDias;
  final String descripcion;
  final List<String> pasos;

  MetodoPreparacion({
    required this.nombre,
    required this.duracionDias,
    required this.descripcion,
    required this.pasos,
  });
}

class SoilCatalog {
  static final List<Map<String, dynamic>> procesos = [
    {
      'tipo': 'Desinfección del suelo',
      'explicacion': 'Elimina patógenos, hongos y nematodos que pueden atacar las raíces desde el primer día.',
      'recomendaciones': 'Realizar preferiblemente en días soleados si se usa solarización. No saltar este paso si hubo plagas antes.',
      'metodos': [
        {
          'nombre': 'Agua Oxigenada y Microorganismos',
          'duracionDias': 10,
          'descripcion': 'Elimina patógenos y repuebla con vida benéfica.',
          'pasos': [
            'Humedecer y picar el suelo.',
            'Riege con 50ml de agua oxigenada por litro de agua al atardecer.',
            'Reposo por 5 días.',
            'Aplique microorganismos líquidos (1L en 1L de agua).',
            'Espere 5 días más antes de sembrar.'
          ]
        },
        {
          'nombre': 'Solarización',
          'duracionDias': 45,
          'descripcion': 'Uso de calor solar para desinfectar (ideal en verano).',
          'pasos': [
            'Cubra el suelo con plástico transparente.',
            'Selle las esquinas con tierra.',
            'Deje expuesto al sol de 30 a 45 días.'
          ]
        },
        {
          'nombre': 'Agua Hirviendo',
          'duracionDias': 2,
          'descripcion': 'Método rápido usando calor directo.',
          'pasos': [
            'Vierta agua hirviendo sobre el espacio de tierra.',
            'Deje en reposo por al menos 2 días.'
          ]
        }
      ]
    },
    {
      'tipo': 'Activación de microorganismos',
      'explicacion': 'Fomenta la vida biológica del suelo para que los nutrientes estén disponibles para la planta.',
      'recomendaciones': 'Mantener la humedad constante y evitar el uso de químicos que maten la biología.',
      'metodos': [
        {
          'nombre': 'Reproducción MM (Sólido)',
          'duracionDias': 30,
          'descripcion': 'Mezcla de bacterias y hongos benéficos para restaurar la vida del suelo.',
          'pasos': [
            'Recolecte una cubeta de tierra de montaña.',
            'Mezcle con media cubeta de pulimento de arroz.',
            'Disuelva 1L de melaza en 2L de agua y humedezca.',
            'Prueba de humedad (no debe gotear).',
            'Compactar en cubeta por capas de 15cm.',
            'Sellar con capa de pulimento.',
            'Tapar herméticamente y dejar reposar 30 días.'
          ]
        },
        {
          'nombre': 'Activado MM (Líquido)',
          'duracionDias': 10,
          'descripcion': 'Fermentación rápida para aplicación directa.',
          'pasos': [
            'Disuelva 2L de melaza en media cubeta de agua.',
            'Ponga 3lb de microorganismos sólidos en una manta y sumerja.',
            'Complete con agua (sin cloro) dejando 10cm vacíos.',
            'Sellar herméticamente por 10 días.'
          ]
        }
      ]
    },
    {
      'tipo': 'Bocashi o abonado',
      'explicacion': 'Aporte de nutrientes de liberación rápida a través de abonos orgánicos fermentados.',
      'recomendaciones': 'El abono debe estar frío y oler a tierra de bosque antes de incorporarlo.',
      'metodos': [
        {
          'nombre': 'Fermentación Bocashi',
          'duracionDias': 15,
          'descripcion': 'Abono completo y fermentado.',
          'pasos': [
            'Mezclar estiércol, rastrojo, tierra, carbón, ceniza y harina.',
            'Humedecer con melaza y microorganismos líquidos.',
            'Mezclar uniformemente hasta 1m de altura.',
            'Voltear diariamente los primeros 5 días.',
            'Voltear cada 2 días del día 6 al 15.'
          ]
        }
      ]
    },
    {
      'tipo': 'Incorporación de materia orgánica',
      'explicacion': 'Mejora la estructura del suelo, permitiendo mejor retención de agua y aireación.',
      'recomendaciones': 'Integrar bien con la tierra existente sin enterrar demasiado profundo.',
      'metodos': [
        {
          'nombre': 'Enmienda Completa',
          'duracionDias': 15,
          'descripcion': 'Integración de restos naturales y microorganismos.',
          'pasos': [
            'Aflojar suelo a 20cm y desinfectar (5 días reposo).',
            'Incorporar microorganismos líquidos (5 días reposo).',
            'Colocar compost o Bocashi (2 paladas por metro).',
            'Mezclar con cal/ceniza y reposar 5 días.'
          ]
        }
      ]
    },
    {
      'tipo': 'Preparación de almácigo',
      'explicacion': 'Preparación del sustrato ideal para las primeras etapas de vida de la planta.',
      'recomendaciones': 'Usar recipientes con buen drenaje y mantener a semisombra.',
      'metodos': [
        {
          'nombre': 'Mezcla Semillero',
          'duracionDias': 10,
          'descripcion': 'Tierra de bosque, arena y desinfección solar.',
          'pasos': [
            'Mezclar 6lb tierra, 2.5lb arena, 1lb gallinaza, 0.5lb ceniza.',
            'Humedecer y tapar con plástico al sol por 7 días.',
            'Reposo adicional de 3 días antes de sembrar.'
          ]
        },
        {
          'nombre': 'Base Bocashi Directo',
          'duracionDias': 1,
          'descripcion': 'Uso directo de Bocashi maduro tamizado.',
          'pasos': [
            'Cuele 1lb de Bocashi.',
            'Mezcle con un puñado de arena de río.',
            'Siembre inmediatamente.'
          ]
        }
      ]
    },
    {
      'tipo': 'Siembra',
      'explicacion': 'Punto final de la preparación donde se coloca la semilla o plántula en su lugar definitivo.',
      'recomendaciones': 'Respetar las distancias de siembra y la profundidad recomendada para cada cultivo.',
      'metodos': [
        {
          'nombre': 'Siembra Directa',
          'duracionDias': 1,
          'descripcion': 'Colocación de semilla en el suelo preparado.',
          'pasos': [
            'Abrir pequeño surco o hueco.',
            'Colocar semilla a profundidad adecuada (2-3 veces su tamaño).',
            'Cubrir ligeramente y regar.'
          ]
        },
        {
          'nombre': 'Trasplante',
          'duracionDias': 1,
          'descripcion': 'Pasar la plántula del almácigo al suelo definitivo.',
          'pasos': [
            'Hacer hoyo del tamaño del pilón.',
            'Colocar plántula con cuidado de no romper raíces.',
            'Presionar ligeramente y regar abundantemente.'
          ]
        }
      ]
    }
  ];
}
