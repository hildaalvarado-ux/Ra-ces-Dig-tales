import 'package:flutter/material.dart';
import '../main.dart';

class HelpDialogs {
  static String textForField(String key) {
    switch (key) {
      case 'Tipo de cultivo':
        return 'Clasifica el cultivo según la parte que se consume: hoja, raíz, frutal, etc.';
      case 'Tipo de siembra':
        return 'Directa: se siembra en el suelo definitivo. Indirecta: se inicia en almácigo/semillero y luego se trasplanta.';
      case 'Temporada de siembra':
        return 'Época del año más recomendable para sembrar según clima y condiciones.';
      case 'Época de siembra':
        return 'Se refiere a si se recomienda siembra temprana, media o tardía dentro de la temporada.';
      case 'Profundidad de semilla':
        return 'Qué tan profundo se coloca la semilla o el diente en el suelo.';
      case 'Distancia entre plantas':
        return 'Espacio recomendado entre una planta y otra para buen desarrollo.';
      case 'Fase lunar':
        return 'Tradición agrícola: algunas personas planifican siembras según fases lunares.';
      case 'Clima ideal':
        return 'Condición climática donde el cultivo se desarrolla mejor.';
      case 'Resistencia al frío':
        return 'Qué tanto soporta temperaturas bajas.';
      case 'Luz solar':
        return 'Cantidad de sol recomendada: plena luz, semisombra, sombra.';
      case 'Riego':
        return 'Frecuencia aproximada de riego recomendada.';
      case 'Cosecha en':
        return 'Tiempo aproximado para cosechar desde la siembra.';
      case 'Temporada de cosecha':
        return 'Época del año donde normalmente se cosecha.';
      case 'Época de cosecha':
        return 'Temprana, media o tardía según el ciclo.';
      default:
        return 'Información de referencia para este campo.';
    }
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String text,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}