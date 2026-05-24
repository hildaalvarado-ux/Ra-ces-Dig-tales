import 'package:flutter/material.dart';
import '../main.dart';

class CreditosPage extends StatelessWidget {
  const CreditosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Créditos',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FadeInAnimation(
                  delay: 0,
                  child: Text(
                    'Créditos del Proyecto',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.greenDarker,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const _FadeInAnimation(
                  delay: 100,
                  child: Text(
                    'Equipo de desarrollo',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenSoft,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                _buildSectionTitle('DESARROLLADORAS'),
                const SizedBox(height: 16),

                const _FadeInAnimation(
                  delay: 200,
                  child: _CreditCard(
                    name: 'Hilda Jazmín Alvarado Hernández',
                    role: 'Desarrollo de lógica y funcionalidades',
                    description: 'Backend y lógica de negocio',
                    icon: '👩‍💻',
                  ),
                ),
                const SizedBox(height: 16),
                const _FadeInAnimation(
                  delay: 300,
                  child: _CreditCard(
                    name: 'Keyri Sarai Saravia Calles',
                    role: 'Diseño de interfaz y experiencia de usuario',
                    description: 'UI/UX',
                    icon: '🎨',
                  ),
                ),
                const SizedBox(height: 16),
                const _FadeInAnimation(
                  delay: 400,
                  child: _CreditCard(
                    name: 'Jenifer Eunice Benites Santos',
                    role: 'Integración y pruebas del sistema',
                    description: 'Testing, validación y soporte técnico',
                    icon: '⚙️',
                  ),
                ),

                const SizedBox(height: 40),

                _buildSectionTitle('COLABORADORES / ENTREVISTADOS'),
                const SizedBox(height: 8),
                const _FadeInAnimation(
                  delay: 450,
                  child: Text(
                    'Participaron con guías y contenido técnico a la app por medio de entrevistas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenSoft,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildResponsiveCard(
                      context,
                      const _FadeInAnimation(
                        delay: 500,
                        child: _CreditCard(
                          name: 'Miguel Angel Ayala',
                          role: 'Técnico y conocimiento experimental',
                          description: 'Asesoría técnica agrícola',
                          icon: '👨‍🌾',
                        ),
                      ),
                    ),
                    _buildResponsiveCard(
                      context,
                      const _FadeInAnimation(
                        delay: 600,
                        child: _CreditCard(
                          name: 'Marvin Leonidas Pineda Romero',
                          role: 'Ingeniero Agroecólogo',
                          description: 'Validación de contenido técnico',
                          icon: '👨‍🔬',
                        ),
                      ),
                    ),
                    _buildResponsiveCard(
                      context,
                      const _FadeInAnimation(
                        delay: 700,
                        child: _CreditCard(
                          name: 'Elmer Romero',
                          role: 'Ingeniero Agroecólogo',
                          description: 'Soporte especializado en agroecología',
                          icon: '👨‍🔬',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),
                const Center(
                  child: _FadeInAnimation(
                    delay: 800,
                    child: Column(
                      children: [
                        Text(
                          'Centro Universitario Regional de Cabañas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.greenDarker,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '© 2026 Raíces Digitales',
                          style: TextStyle(
                            color: AppColors.greenSoft,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return _FadeInAnimation(
      delay: 150,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.greenAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.greenDark.withOpacity(0.6),
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveCard(BuildContext context, Widget card) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width > 700 ? (width - 56) / 2 : double.infinity,
      child: card,
    );
  }
}

class _CreditCard extends StatelessWidget {
  final String name;
  final String role;
  final String description;
  final String icon;
  final bool isPlaceholder;

  const _CreditCard({
    required this.name,
    required this.role,
    required this.description,
    required this.icon,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isPlaceholder ? 0.6 : 0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isPlaceholder
            ? AppColors.greenDark.withOpacity(0.1)
            : AppColors.greenDark.withOpacity(0.15),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenDark.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 70,
              color: isPlaceholder
                ? AppColors.greenDark.withOpacity(0.05)
                : AppColors.greenDark.withOpacity(0.08),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: isPlaceholder ? AppColors.greenSoft : AppColors.greenDarker,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.greenDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadeInAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const _FadeInAnimation({required this.child, required this.delay});

  @override
  State<_FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<_FadeInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    if (widget.delay == 0) {
      _controller.forward();
    } else {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
