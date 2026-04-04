import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../data/db_instance.dart';
import '../main.dart';

class NotificacionesConfigPage extends StatefulWidget {
  final int userId;
  const NotificacionesConfigPage({super.key, required this.userId});

  @override
  State<NotificacionesConfigPage> createState() => _NotificacionesConfigPageState();
}

class _NotificacionesConfigPageState extends State<NotificacionesConfigPage> {
  User? _user;
  bool _loading = true;

  final List<String> _sounds = ['default', 'naturaleza', 'campana', 'suave'];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    final user = await appDb.getUserById(widget.userId);
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  Future<void> _updateSettings({bool? enabled, String? sound}) async {
    if (_user == null) return;

    final newEnabled = enabled ?? _user!.notificationsEnabled;
    final newSound = sound ?? _user!.notificationSound;

    await appDb.updateUserNotificationSettings(widget.userId, newEnabled, newSound);
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text('Configuración de Notificaciones',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Alertas y Recordatorios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.greenDarker,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestiona cómo quieres recibir los avisos de tus cultivos.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenSoft.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildSwitchCard(
                    title: 'Activar notificaciones',
                    subtitle: 'Recibe alertas sobre riego, abono y otras tareas.',
                    value: _user?.notificationsEnabled ?? true,
                    onChanged: (val) => _updateSettings(enabled: val),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Personalización',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.greenDarker,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSoundSelector(),
                ],
              ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenDarker,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.greenSoft.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSoundSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.1)),
      ),
      child: Column(
        children: _sounds.map((sound) {
          final isSelected = _user?.notificationSound == sound;
          return Column(
            children: [
              ListTile(
                onTap: () => _updateSettings(sound: sound),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.greenAccent : Colors.grey,
                ),
                title: Text(
                  sound[0].toUpperCase() + sound.substring(1),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? AppColors.greenDarker : Colors.black87,
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.greenAccent) : null,
              ),
              if (sound != _sounds.last)
                Divider(height: 1, color: AppColors.greenDark.withOpacity(0.05)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
