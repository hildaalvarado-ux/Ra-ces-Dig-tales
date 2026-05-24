import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../data/db_instance.dart';
import '../data/image_utils.dart';
import '../main.dart';

class PerfilPage extends StatefulWidget {
  final int userId;
  const PerfilPage({super.key, required this.userId});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  User? _user;
  bool _loading = true;
  bool _showPassword = false;

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

  Future<void> _changeAvatar() async {
    final newPath = await ImageUtils.pickAndSaveImage('avatars');
    if (newPath != null) {
      // Delete old avatar if exists
      if (_user?.avatarPath != null) {
        await ImageUtils.deleteImage(_user!.avatarPath);
      }
      await appDb.updateUserAvatar(widget.userId, newPath);
      _loadUser();
    }
  }

  Future<void> _editName() async {
    final ctrl = TextEditingController(text: _user?.fullName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nombre completo'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != _user?.fullName) {
      await appDb.updateUserName(widget.userId, result);
      _loadUser();
    }
  }

  Future<void> _changePassword() async {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool hidePass = true;
    bool hideConfirm = true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Cambiar contraseña'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: passCtrl,
                  obscureText: hidePass,
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(hidePass ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setDialogState(() => hidePass = !hidePass),
                    ),
                  ),
                  validator: (v) => (v?.length ?? 0) < 6 ? 'Mínimo 6 caracteres' : null,
                ),
                TextFormField(
                  controller: confirmCtrl,
                  obscureText: hideConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(hideConfirm ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setDialogState(() => hideConfirm = !hideConfirm),
                    ),
                  ),
                  validator: (v) => v != passCtrl.text ? 'No coinciden' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('CAMBIAR'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      await appDb.updateUserPassword(widget.userId, passCtrl.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña actualizada correctamente')),
        );
      }
    }
  }

  Widget _buildAvatar() {
    ImageProvider? provider;
    if (_user?.avatarPath != null) {
      final path = _user!.avatarPath!;
      if (path.startsWith('data:image')) {
        final bytes = ImageUtils.dataUriToBytes(path);
        if (bytes != null) provider = MemoryImage(bytes);
      } else if (kIsWeb) {
        provider = NetworkImage(path);
      } else {
        provider = FileImage(File(path));
      }
    }

    return Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: CircleAvatar(
            backgroundColor: AppColors.greenSoft.withOpacity(0.2),
            backgroundImage: provider,
            child: provider == null
                ? const Icon(Icons.person_rounded, size: 80, color: AppColors.greenDark)
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _changeAvatar,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.greenAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
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
          title: const Text('Perfil', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: const BoxDecoration(
                        color: AppColors.greenDark,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildAvatar(),
                          const SizedBox(height: 16),
                          Text(
                            _user?.fullName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '@${_user?.username ?? ''}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _InfoCard(
                            icon: Icons.person_outline_rounded,
                            title: 'Nombre completo',
                            value: _user?.fullName ?? '',
                            onEdit: _editName,
                          ),
                          const SizedBox(height: 12),
                          _InfoCard(
                            icon: Icons.email_outlined,
                            title: 'Correo electrónico',
                            value: _user?.email ?? '',
                          ),
                          const SizedBox(height: 12),
                          _InfoCard(
                            icon: Icons.lock_outline_rounded,
                            title: 'Contraseña',
                            value: _showPassword ? (_user?.password ?? '') : '••••••••',
                            onEdit: _changePassword,
                            actionLabel: 'Cambiar',
                            trailing: IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.greenAccent,
                              ),
                              onPressed: () => setState(() => _showPassword = !_showPassword),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onEdit;
  final String actionLabel;
  final Widget? trailing;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onEdit,
    this.actionLabel = 'Editar',
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.greenDark.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.greenDark, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.greenSoft.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.greenDarker,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (onEdit != null)
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.greenAccent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
        ],
      ),
    );
  }
}
