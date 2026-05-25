import '../data/common_widgets.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../data/db_instance.dart';
import 'perfil.dart';
import 'notificaciones_config.dart';
import 'rendimiento.dart';
import 'apariencia.dart';
import 'ayuda.dart';
import 'contacto.dart';
import 'creditos.dart';

class OpcionesPage extends StatelessWidget {
  final int userId;
  const OpcionesPage({super.key, required this.userId});

  Future<bool> _confirmLogout(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Quieres cerrar tu sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenDarker,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sí'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await _confirmLogout(context);
    if (!ok) return;

    await appDb.clearSession();
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/appgate', (_) => false);
  }

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
            'Configuración',
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
                  icon: Icons.palette_rounded,
                  label: 'Apariencia',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AparienciaPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.speed_rounded,
                  label: 'Rendimiento',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RendimientoPage(userId: userId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.help_rounded,
                  label: 'Ayuda',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AyudaPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.contact_mail_rounded,
                  label: 'Contacto',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContactoPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _OptionButton(
                  icon: Icons.info_outline_rounded,
                  label: 'Créditos',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreditosPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _OptionButton(
                  icon: Icons.logout_rounded,
                  label: 'Cerrar sesión',
                  color: Colors.red.shade700,
                  onTap: () => _logout(context),
                ),

                const SizedBox(height: 40),
                const CopyrightFooter(),
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
  final Color? color;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.greenDark;
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
                  color: effectiveColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: color ?? AppColors.greenDarker,
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
