import 'package:flutter/material.dart';
import '../main.dart';

class AyudaPage extends StatelessWidget {
  const AyudaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.greenDark,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Ayuda',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
bottom: const TabBar(
  indicatorColor: Colors.white,
  indicatorWeight: 4,
  labelColor: Colors.white, // 👈 texto seleccionado
  unselectedLabelColor: Colors.white70, // 👈 texto no seleccionado (más suave)
  labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
  tabs: [
    Tab(text: 'Tutorial'),
    Tab(text: 'FAQ'),
  ],
            ),
          ),
          body: const TabBarView(
            children: [
              _TutorialSection(),
              _FAQSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialSection extends StatelessWidget {
  const _TutorialSection();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guía de Uso',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.greenDarker,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aprende a sacar el máximo provecho de Raíces Digitales',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.greenSoft.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),

          _buildStep(
            icon: Icons.local_florist_rounded,
            title: 'Explora y Gestiona Cultivos',
            description: 'En la sección "Cultivos", puedes ver el catálogo predeterminado, añadir tus propios cultivos o importar los compartidos por la comunidad. Toca un cultivo para ver detalles de siembra, riego y cuidados.',
          ),
          _buildStep(
            icon: Icons.calendar_month_rounded,
            title: 'Planifica con el Calendario',
            description: 'Al iniciar un plan de cultivo desde los detalles, se generarán automáticamente tareas en tu calendario (riego, fertilización, cosecha). Puedes marcar tareas como completadas para llevar el control.',
          ),
          _buildStep(
            icon: Icons.notifications_active_rounded,
            title: 'Recibe Notificaciones',
            description: 'La app te enviará recordatorios locales de tus tareas diarias. Puedes configurar los sonidos y habilitar/deshabilitar alertas en la sección de Notificaciones dentro de Opciones.',
          ),
          _buildStep(
            icon: Icons.menu_book_rounded,
            title: 'Bitácora de Seguimiento',
            description: 'Usa el "Diario" para registrar observaciones, fotos y el estado de tus plantas. Esto te ayudará a identificar patrones y mejorar tus técnicas de cultivo.',
          ),
          _buildStep(
            icon: Icons.bug_report_rounded,
            title: 'Control de Plagas y Fertilizantes',
            description: 'Consulta los módulos especializados para aprender a combatir plagas de forma orgánica o química, y descubre recetas para crear tus propios fertilizantes caseros.',
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.greenDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greenDark.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.greenDark),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Consejo: Revisa periódicamente tu calendario para no olvidar las necesidades de tus plantas.',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenDarker,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.greenDark, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.greenDarker,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenDarker.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQSection extends StatelessWidget {
  const _FAQSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Preguntas Frecuentes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.greenDarker,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Resolvimos tus dudas más comunes',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.greenSoft.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 24),

        _buildFAQItem(
          question: '¿Cómo crear un cultivo?',
          answer: 'Ve a la sección "Cultivos" desde el inicio. Toca el botón flotante "+" en la esquina inferior derecha. Completa el formulario con el nombre, tipo, meses de cosecha y una imagen opcional. Al guardar, aparecerá en tu lista de "Mis Cultivos".',
        ),
        _buildFAQItem(
          question: '¿Cómo eliminar un cultivo?',
          answer: 'En la lista de "Mis Cultivos", mantén presionado el cultivo que deseas borrar o toca el icono de papelera si está visible. También puedes eliminar planes activos desde el Calendario seleccionando el plan y eligiendo "Eliminar Cultivo".',
        ),
        _buildFAQItem(
          question: '¿Por qué no recibo notificaciones?',
          answer: 'Asegúrate de que las notificaciones estén activadas en Opciones > Notificaciones. Además, verifica que la aplicación tenga permisos de notificaciones en los ajustes de tu sistema operativo (Android/iOS).',
        ),
        _buildFAQItem(
          question: '¿Cómo inicio un plan de siembra?',
          answer: 'Busca el cultivo que deseas sembrar en el catálogo o en tu lista personal. Abre los detalles y presiona el botón "Iniciar Plan de Cultivo". Sigue los pasos para configurar la fecha de inicio y hora preferida para recordatorios.',
        ),
        _buildFAQItem(
          question: '¿Los datos se guardan en la nube?',
          answer: 'Actualmente, Raíces Digitales v1 almacena tus datos de forma local en tu dispositivo para garantizar tu privacidad y funcionamiento sin internet.',
        ),

        const SizedBox(height: 30),
        Center(
          child: Text(
            '¿Aún tienes dudas?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.greenSoft.withOpacity(0.9),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            // Próximamente contacto
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Módulo de contacto próximamente.')),
            );
          },
          icon: const Icon(Icons.mail_rounded),
          label: const Text('Contactar Soporte'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenDark,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.greenDarker,
            fontSize: 16,
          ),
        ),
        iconColor: AppColors.greenDark,
        collapsedIconColor: AppColors.greenSoft,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.greenDarker.withOpacity(0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
