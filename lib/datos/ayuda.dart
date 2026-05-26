import 'package:flutter/material.dart';
import '../main.dart';
import 'contacto.dart';
import 'cultivos.dart';
import 'fertilizantes.dart';
import 'plagas.dart';
import 'enfermedades.dart';
import 'pesticidas.dart';
import 'calendario.dart';
import 'notificaciones.dart';
import 'diario.dart';
import 'preparacion_suelo.dart';

class AyudaPage extends StatelessWidget {
  final int userId;
  const AyudaPage({super.key, required this.userId});

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
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: 'Tutorial'),
                Tab(text: 'FAQ'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _TutorialSection(userId: userId),
              const _FAQSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialSection extends StatelessWidget {
  final int userId;
  const _TutorialSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Guía de Uso Interactiva',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.greenDarker,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explora cada sección de Raíces Digitales para aprender cómo funciona.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.greenSoft.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 24),

        _buildStep(
          context,
          icon: Icons.local_florist_rounded,
          title: 'Gestión de Cultivos',
          description: 'Consulta el catálogo, añade tus propios cultivos e inicia planes de siembra personalizados.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CultivosPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.calendar_month_rounded,
          title: 'Calendario y Tareas',
          description: 'Controla el riego, fertilización y cosecha. Marca tareas como completadas para llevar un seguimiento real.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarioPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.layers_rounded,
          title: 'Preparación de Suelo',
          description: 'Aprende los pasos vitales antes de sembrar para asegurar el éxito de tu cosecha.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PreparacionSueloPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.menu_book_rounded,
          title: 'Diario de Campo',
          description: 'Registra observaciones diarias, fotos y el progreso detallado de cada una de tus plantas.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiarioPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.bug_report_rounded,
          title: 'Control de Insectos',
          description: 'Identifica insectos beneficiosos y plagas, con soluciones orgánicas para combatirlas.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlagasPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.science_rounded,
          title: 'Fertilizantes Caseros',
          description: 'Descubre cómo crear tus propios abonos orgánicos con materiales sencillos y económicos.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FertilizantesPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.sanitizer_rounded,
          title: 'Repelentes Naturales',
          description: 'Recetas para proteger tus cultivos de forma ecológica sin usar químicos dañinos.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PesticidasPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.biotech_rounded,
          title: 'Enfermedades',
          description: 'Guía visual para detectar y tratar enfermedades comunes en el huerto.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EnfermedadesPage(userId: userId))),
        ),
        _buildStep(
          context,
          icon: Icons.notifications_active_rounded,
          title: 'Notificaciones',
          description: 'Configura recordatorios y mantente al tanto de todas las necesidades de tu huerta.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificacionesPage(userId: userId))),
        ),

        const SizedBox(height: 10),
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
                  'Sugerencia: Puedes usar los botones "Ir" para navegar directamente a cada sección y probar las funciones.',
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
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.greenDark.withOpacity(0.1),
                  shape: BoxShape.circle,
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
                        fontSize: 18,
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('ABRIR MÓDULO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
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
          question: '¿Qué es Raíces Digitales?',
          answer: 'Una plataforma para la gestión integral y orgánica de cultivos, diseñada para ayudarte a cultivar de forma sostenible.',
        ),
        _buildFAQItem(
          question: '¿Cómo inicio un plan de cultivo?',
          answer: 'Selecciona un cultivo del catálogo o de tus registros personales y presiona "EMPEZAR PLAN DE CULTIVO". Podrás configurar la fecha de inicio y recordatorios.',
        ),
        _buildFAQItem(
          question: '¿Para qué sirve la Preparación de Suelo?',
          answer: 'Es una guía paso a paso para asegurar que tu tierra esté en condiciones óptimas antes de la siembra, incluyendo limpieza, abonado y nivelación.',
        ),
        _buildFAQItem(
          question: '¿Cómo registro el progreso de mis plantas?',
          answer: 'Usa el botón "AGREGAR OBSERVACIÓN" en el Calendario. Podrás anotar el estado de salud, la etapa de crecimiento y si detectaste plagas o realizaste riegos.',
        ),
        _buildFAQItem(
          question: '¿Puedo compartir o respaldar mi información?',
          answer: '¡Sí! Puedes exportar tus cultivos y registros como archivos .rdc para compartirlos con otros usuarios o importarlos en un nuevo dispositivo.',
        ),
        _buildFAQItem(
          question: '¿Cómo ajusto el tamaño del texto?',
          answer: 'Dirígete a Configuración (icono de engranaje) y usa el selector de tamaño de texto para mejorar la legibilidad según tu preferencia.',
        ),
        _buildFAQItem(
          question: '¿Mis datos están seguros y privados?',
          answer: 'Sí. Raíces Digitales almacena toda tu información localmente en tu dispositivo. No necesitas conexión a internet para la mayoría de funciones.',
        ),
        _buildFAQItem(
          question: '¿Qué ventajas tiene la versión móvil?',
          answer: 'La versión móvil permite recibir notificaciones push en tiempo real para tus tareas y descargar el instalador APK para uso offline garantizado.',
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactoPage()),
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
        const SizedBox(height: 40),
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
