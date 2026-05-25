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
          question: '¿Cómo crear un cultivo?',
          answer: 'Ve a la sección "Cultivos" desde el inicio o el tutorial. Toca el botón flotante "+" en la esquina inferior derecha. Completa el formulario con los datos de tu planta. Al guardar, aparecerá en tu lista de "Mis Cultivos".',
        ),
        _buildFAQItem(
          question: '¿Cómo eliminar un cultivo?',
          answer: 'En la lista de "Mis Cultivos", mantén presionado el cultivo que deseas borrar o usa el botón de eliminar en sus detalles. También puedes eliminar planes activos desde el Calendario.',
        ),
        _buildFAQItem(
          question: '¿Por qué no recibo notificaciones?',
          answer: 'Asegúrate de que las notificaciones estén activadas en Opciones > Notificaciones. Además, verifica los permisos de la app en los ajustes de tu teléfono.',
        ),
        _buildFAQItem(
          question: '¿Cómo inicio un plan de siembra?',
          answer: 'Busca el cultivo en el catálogo o en tu lista personal. Abre los detalles y presiona "EMPEZAR PLAN DE CULTIVO". Podrás elegir la fecha de inicio y la hora de tus recordatorios.',
        ),
        _buildFAQItem(
          question: '¿Los datos se guardan en la nube?',
          answer: 'Actualmente, Raíces Digitales almacena tus datos de forma local en tu dispositivo para garantizar tu privacidad y funcionamiento sin internet.',
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
