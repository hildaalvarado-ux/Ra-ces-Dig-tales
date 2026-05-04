import 'dart:convert';

class TareaPreparacion {
  final String tipo;
  final String? metodoSeleccionado;
  final int duracionDias;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String estado; // "pendiente", "en_proceso", "completado"

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
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFin: fechaFin ?? this.fechaFin,
    estado: estado ?? this.estado,
  );
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
      'tipo': 'Microorganismos de montaña (Sólido)',
      'metodos': [
        {
          'nombre': 'Reproducción sólido',
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
        }
      ]
    },
    {
      'tipo': 'Microorganismos de montaña (Líquido)',
      'metodos': [
        {
          'nombre': 'Activado líquido (Hongos)',
          'duracionDias': 10,
          'descripcion': 'Fermentación de 4 a 10 días para control de hongos.',
          'pasos': [
            'Disuelva 2L de melaza en media cubeta de agua.',
            'Ponga 3lb de microorganismos sólidos en una manta y sumerja.',
            'Complete con agua (sin cloro) dejando 10cm vacíos.',
            'Sellar herméticamente por 10 días.'
          ]
        },
        {
          'nombre': 'Activado líquido (Bacterias)',
          'duracionDias': 15,
          'descripcion': 'Fermentación de 10 a 15 días para control de bacterias.',
          'pasos': [
            'Disuelva 2L de melaza en media cubeta de agua.',
            'Ponga 3lb de microorganismos sólidos en una manta y sumerja.',
            'Complete con agua (sin cloro) dejando 10cm vacíos.',
            'Sellar herméticamente por 15 días.'
          ]
        }
      ]
    },
    {
      'tipo': 'Abono Orgánico Bocashi',
      'metodos': [
        {
          'nombre': 'Fermentación Bocashi',
          'duracionDias': 15,
          'descripcion': 'Mejora el suelo y aporta minerales de forma natural.',
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
      'tipo': 'Desinfección del suelo',
      'metodos': [
        {
          'nombre': 'Agua Oxigenada y Microorganismos',
          'duracionDias': 10,
          'descripcion': 'Elimina hongos y nematodos con agua oxigenada.',
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
      'tipo': 'Preparación para Semillero',
      'metodos': [
        {
          'nombre': 'Mezcla Tradicional',
          'duracionDias': 10,
          'descripcion': 'Tierra de bosque, arena y desinfección solar.',
          'pasos': [
            'Mezclar 6lb tierra, 2.5lb arena, 1lb gallinaza, 0.5lb ceniza.',
            'Humedecer y tapar con plástico al sol por 7 días.',
            'Reposo adicional de 3 días antes de sembrar.'
          ]
        },
        {
          'nombre': 'Base Bocashi',
          'duracionDias': 1,
          'descripcion': 'Uso directo de Bocashi maduro.',
          'pasos': [
            'Cuele 1lb de Bocashi.',
            'Mezcle con un puñado de arena de río.',
            'Siembre inmediatamente.'
          ]
        }
      ]
    },
    {
      'tipo': 'Incorporación de Materia Orgánica',
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
    }
  ];
}
