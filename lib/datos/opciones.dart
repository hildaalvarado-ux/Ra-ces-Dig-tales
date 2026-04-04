import 'package:flutter/material.dart';
import '../main.dart';
import 'perfil.dart';
import 'notificaciones_config.dart';

class OpcionesPage extends StatelessWidget {
  final int userId;
  const OpcionesPage({super.key, required this.userId});

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
            'Opciones',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configuración',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.greenDarker,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Personaliza tu experiencia en Raíces Digitales',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenSoft.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),

                _OptionButton(
                  icon: Icons.person_rounded,
                  label: 'Perfil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PerfilPage(userId: userId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.notifications_rounded,
                  label: 'Notificaciones',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificacionesConfigPage(userId: userId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.speed_rounded,
                  label: 'Rendimiento',
                  onTap: () => _showPlaceholder(context, 'Rendimiento'),
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.palette_rounded,
                  label: 'Apariencia',
                  onTap: () => _showPlaceholder(context, 'Apariencia'),
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.help_rounded,
                  label: 'Ayuda',
                  onTap: () => _showPlaceholder(context, 'Ayuda'),
                ),

                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Raíces Digitales v1.0.0',
                    style: TextStyle(
                      color: AppColors.greenSoft.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('La opción "$title" estará disponible próximamente.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.greenDark,
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.greenDark.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.greenDark.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.greenDark,
                  size: 26,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenDarker,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.greenSoft.withOpacity(0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
