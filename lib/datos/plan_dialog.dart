import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_database.dart';
import '../data/crop_models.dart';
import '../data/db_instance.dart';
import '../main.dart';
import '../data/crop_service.dart';
import 'calendario.dart';

Future<void> showStartPlanDialog(BuildContext context, {
  required Cultivo cultivo,
  DateTime? initialDate,
  bool isRisk = false,
}) async {
  DateTime selectedDate = initialDate ?? DateTime.now();
  DateTime minDate = initialDate ?? DateTime.now().subtract(const Duration(days: 30));

  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);
  final nicknameCtrl = TextEditingController();
  Color selectedColor = Colors.green;
  bool isAlmacigo = cultivo.guiaRapida?['usaAlmacigo'] == true;

  final colors = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.pink,
  ];

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Programar Cultivo', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Dale un nombre y color a este cultivo para identificarlo en el calendario:'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nicknameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Apodo (ej: Lechuga de la abuela)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Color en el calendario:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: colors.map((c) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedColor = c),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == c ? Colors.black : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  ListTile(
                    title: const Text('Fecha de inicio'),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: minDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                  ),
                  ListTile(
                    title: const Text('Hora de tareas'),
                    subtitle: Text(selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) setState(() => selectedTime = picked);
                    },
                  ),
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('¿Sembrar en almácigo?', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Si se selecciona, el plan incluirá una tarea de trasplante.'),
                    value: isAlmacigo,
                    activeColor: AppColors.greenDark,
                    onChanged: (v) => setState(() => isAlmacigo = v ?? false),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenDark, foregroundColor: Colors.white),
                child: const Text('GENERAR PLAN'),
              ),
            ],
          );
        },
      );
    },
  );

  if (result == true) {
    final userId = await appDb.getActiveUserId();
    if (userId == null) return;

    try {
      await CropPlanGenerator.generate(
        userId: userId,
        cultivo: cultivo,
        startDate: selectedDate,
        preferredTime: selectedTime,
        nickname: nicknameCtrl.text.trim().isEmpty ? null : nicknameCtrl.text.trim(),
        colorValue: selectedColor.value,
        isAlmacigoOverride: isAlmacigo,
        isRisk: isRisk,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plan para ${cultivo.nombre} generado con éxito.')),
        );

        // Using rootNavigator: true to ensure we jump out of any modal bottom sheets if they exist
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => CalendarioPage(userId: userId, initialDate: selectedDate)),
          (route) => route.isFirst, // Goes back to Dashboard or whatever is the first route below this
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el plan: $e')),
        );
      }
    }
  }
}
